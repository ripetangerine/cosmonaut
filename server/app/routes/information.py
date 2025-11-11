from contextlib import asynccontextmanager
from fastapi import APIRouter, Query
import httpx
import random 
import datetime
import xmltodict

import mars_time
import app.schema.manager.manager as SchemaManager
from app.config import settings


# TODO : 천체 정보 추가, 랜덤처리 추가

router = APIRouter(
  prefix="/information"
)

@asynccontextmanager
async def lifespan(app=None):
  global db
  db = await SchemaManager.Manager.init()
  try:
    yield
  except Exception:
    await db.connect.close()


# DB 초기화문
db : SchemaManager = None

# 천문 현상 정보 랜덤 반환
# 월 단위 
@router.get('/calender')
async def get_calender(
  year: int = Query(...), 
  month: int = Query(...)
  ):
  # 클라이언트에서 요청을 할때 년/월 정보를 제공
  URL = "http://apis.data.go.kr/B090041/openapi/service/AstroEventInfoService/getAstroEventInfo"
  API_KEY = settings.ASTRO_OPEN_API_KEY
  params = {
    "serviceKey" : f"{API_KEY}",
    "solYear": year,
    "solMonth" : f"{month:02d}"
  }
  async with httpx.AsyncClient() as client:
    try:
      response = await client.get(URL, params=params, timeout=5.0)
      response.raise_for_status() 
      # xml 변환
      data_dict = xmltodict.parse(response.text)
      return data_dict  

    except httpx.HTTPStatusError as e:
      print(f"calender API 요청 실패: 상태 코드 {e.response.status_code} for {e.request.url}")
      return {"error": f"calender API에서 오류 응답을 받았습니다: {e.response.status_code}"}

    except httpx.RequestError as e:
      # 네트워크, 타임아웃
      print(f"API 요청 중 오류 발생: {e.request.url} - {e}")
      return {"error": "화성 날짜를 불러올 수 없습니다."}
    

# 천체에 대해서 랜덤 정보를 제공하는 라우트 -> /mars, /earth, /solar
@router.get('/mars')
async def mars():
  try:
    data:str = await db.select("Mars", random.randrange(1, 2))
  except Exception as e:
    print(f"화성 정보 불러오기 에러 : {e}")
    return {"error": str(e)}
  return data


@router.get('/mars/date')
def mars_date():
  now = datetime.now()
  mars = mars_time.datetime_to_marstime(now.year, now.month, now.day)
  sol = ".0f".format(mars.sol)
  return sol


@router.get('/solar')
async def solarInfo():
  try:
    data : str = await db.select("Solar", random.randrange(1, 2))
  except Exception as e:
    print(f"태양 정보 불러 오기 에러 : {e}")
    return {"error" : str(e)}
  return data


@router.get('/earth')
async def earthInfo():
  try:
    data : str = await db.select("Earth", random.randrange(1, 2))
  except Exception as e:
    print(f"지구 정보 불러오기 에러 : {e}")
    return {"error" : str(e)}
  return data

