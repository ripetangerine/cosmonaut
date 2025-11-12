from contextlib import asynccontextmanager
import json
from fastapi import APIRouter, Query
import app.schema.manager.manager as SchemaManager
from app.config import settings
import httpx
from datetime import datetime, timezone
from math import sin, cos, asin, acos, pi
from typing import List
from pydantic import BaseModel
import os


@asynccontextmanager
async def lifespan():
  global db
  db = await SchemaManager.Manager.init()
  try:
    yield
  except Exception:
    db.connect.close()

router = APIRouter(
  prefix="/observation",
)


API_KEY = settings.ASTRO_OPEN_API_KEY
NASA_URL = "https://api.nasa.gov/"
API_PATH = {
  # solar
  "notification" : "DONKI/notifications?type=all",
  # earth
  "IPS" : "DONKI/IPS?", # q = startDate, endDate, location, catalog | 지구 충격파
  "GST" : "DONKI/GST?", # q = startDate, endDate
  # earth, mars (공통)
  "neoWs" : "neo/rest/v1/feed?", # q = startDate, endDate
}


# 관측일지 최신 정보 가져오기
@router.get('/')
async def get_observation(
  type: str = Query(...), 
  startDate: str = Query(...), 
  endDate: str = Query(...)
  ):

  params = {
  "API_KEY" : API_KEY,
  "format" : "json",
  "startDate" : f"{startDate:02d}",
  "endDate" : f"{endDate:02d}",
  }

  # 하루치 데이터만 db에서 관리 : 날짜가 다르다면 db 삭제
  if(datetime.today() != await db.custom("SELECT date_log FROM ObservationDailyLog ORDER BY date_log DESC LIMIT 1")):
    try:
      await db.delete("ObservationDailyLog")
    except Exception as e:
      print(f"ObservationDailyLog db 삭제 오류 : {e}")


  # nasa api 호출 -> 변경 사항 발견 -> db 접근 -> db 중복 검사 -> db에서 마지막 요소 불러오기
  if(type == "solar"):
    async with httpx.AsyncClient() as client:
      try:
        response = await client.get(f'{NASA_URL}{API_PATH["notification"]}', params=params)
        # 응답 -> db에서 중복 검색 -> 없다면 db 삽입(있으면 무시) 
        # 반환 : db에서 마지막으로 삽입한 요소를 반환
        # 조건에서 id로 중복을 탐색하고 중복이 없다면 삽입
        if(not(await db.select("ObservationDailyLog", "response.messageID"))):
          await db.insert("ObservationDailyLog", (
            response.messageID, 
            'solar', 
            datetime.now().strftime("%Y-%m-%d"),
            datetime.now().strftime("%H:%M"),
            response.messageType, # >> FLR 과같은 이벤트 타입 
            response.messageBody,
          ))
      except Exception as e:
        print(f"관측일지 에러 발생 : {e}")
        return {"error" : str(e)}
      
  elif(type == "earth"):
    async with httpx.AsyncClient() as client:
      try:
        response_GST = client.get(f"{NASA_URL}{API_PATH['GST']}", params=params)
        params["location"] = "Earth"
        response_IPS = client.get(f"{NASA_URL}{API_PATH['IPS']}", params=params)
        if(
          not(await db.select("ObservationDailyLog", "response_GST.gstID"))
          and not(await db.select("ObservationDailyLog", "response_GST.gstID"))
        ):
          await db.insert("ObservationDailyLog",(
            response_GST.gstID,
            'earth',
            datetime.now().strftime("%Y-%m-%d"),
            datetime.now().strftime("%H:%M"),
            "GST(전자기 폭풍) 발생",
            f"{response_GST.startTime}에 전자기 폭풍이 발생했습니다."
          ))
          await db.insert("ObservationDailyLog",(
            response_IPS.activityID,
            datetime.now().strftime("%Y-%m-%d"),
            datetime.now().strftime("%H:%M"),
            "ISP(행성 간 충격) 발생",
            f"지구 근처에서 태양에서 온 충격파가 지구 주변에 도달했습니다. 태양폭발(CME)과 지자기 폭풍(GST)과 연관된 현상입니다. 데이터는 NASA의 {response_IPS.instruments.displayName} 관측 장비에서 수집되었습니다.",
          ))
      except Exception as e:
        print(f"관측일지 에러 발생 : {e}")
        return {"error" : str(e)}

  # 추후 화성 관련 api 개발 예정
  # elif(type== "mars"):
  #   return 
  return await db.custom("SELECT * FROM ObservationDailyLog ORDER BY id DESC LIMIT 3;")
    

# 관측일지 전체
@router.get('/all')
async def observation_all(type: str = Query(...)):
  return await db.custom(f"SELECT * FROM ObservationDailyLog WHERE object_type={type};").json()

class StarReq(BaseModel):
  lat : float
  lon : float
  datetime : datetime

class StarRes(BaseModel):
  id: int
  name : str
  mag : float
  alt : float
  az : float

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
stars_path = os.path.join(BASE_DIR, "..", "public", "data", "stars.json")

# star 데이터 가져오기
try:
  with open(os.path.abspath(stars_path), "r", encoding="utf-8") as f:
    STARS_DATA = json.load(f)
except FileNotFoundError as e:
  print("파일 못찾음 ㅅㄱㅂ"+str(e))

# 별 위치 가져오기
@router.post('/position', response_model=List[StarRes])
def star_position(data : StarReq):

  # 시간 -> jd
  jd = datetime_to_julian(data.datetime)
  # jd -> 그리니치 -> 지역 
  # 우주 좌표 (ra/dec) >> 관측 좌표 alt/az
  gmst = gmst_from_julian(jd)
  lst = normalize_deg(gmst + data.lon)

  visible_star = []

  for star in STARS_DATA:
    alt, az = ra_dec_to_alt_az(
      ra_deg = star["ra"], # 도 기준
      dec_deg= star["dec"],
      lat_deg= data.lat,
      lst_deg = lst
    )
    if alt > 0:
      visible_star.append(
        StarRes(
          id = star["id"],
          name = star["name"],
          mag = star["mag"],
          alt = alt,
          az = az
        )
      )
  return visible_star

# == 계산함수
def normalize_deg(d: float) -> float:
  d = d % 360.0
  if d < 0:
    d += 360.0
  return d

def datetime_to_julian(date: datetime) -> float:
  # UTC -> jd
  if date.tzinfo is None:
    date = date.replace(tzinfo=timezone.utc)
  else:
    date = date.astimezone(timezone.utc)

  year = date.year
  month = date.month
  day = date.day + (date.hour + (date.minute + date.second / 60.0) / 60.0) / 24.0

  if month <= 2:
    year -= 1
    month += 12

  A = year // 100
  B = 2 - A + (A // 4)

  jd = int(365.25 * (year + 4716)) + int(30.6001 * (month + 1)) + day + B - 1524.5
  return jd


def gmst_from_julian(jd: float) -> float:
  # Julian Day -> GMST (deg)
  # 기준: J2000.0
  T = (jd - 2451545.0) / 36525.0
  gmst = 280.46061837 + 360.98564736629 * (jd - 2451545.0) + 0.000387933 * T**2 - (T**3) / 38710000.0
  return normalize_deg(gmst)


def deg2rad(d: float) -> float:
  return d * pi / 180.0

def rad2deg(r: float) -> float:
  return r * 180.0 / pi

def ra_dec_to_alt_az(
    ra_deg: float, 
    dec_deg: float, 
    lat_deg: float, 
    lst_deg: float
  ):
  # ra/dec (deg) -> alt/az (deg) 사용자 좌표로 변경
  dec = deg2rad(dec_deg)
  lat = deg2rad(lat_deg)
  ha = deg2rad(normalize_deg(lst_deg - ra_deg))

  # 구면삼각
  sin_alt = sin(dec) * sin(lat) + cos(dec) * cos(lat) * cos(ha)
  alt = asin(sin_alt)
  cos_az = (sin(dec) - sin(alt) * sin(lat)) / (cos(alt) * cos(lat))

  if cos_az > 1.0:
    cos_az = 1.0
  elif cos_az < -1.0:
    cos_az = -1.0

  az = acos(cos_az)

  if sin(ha) > 0:
    az = 2 * pi - az

  return rad2deg(alt), rad2deg(az)
