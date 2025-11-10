from fastapi import APIRouter, Query
import schema.schema_manager as SchemaManager
import config
import httpx
import datetime as date

# TODO : 프론트에서 진행
# 프론트에서
# 사용자 현재 위치 가져오기
# @router.get('/location')
# def observation_location():
#   return ''

# 관측 일지의 단어 검색
# @router.get('/search/')
# async def search_word(
#   q : str = Query(default=None, min_length=2, max_length=20)
# ):
#   # AI 검색 후 문자열 반환
#   return ''


router = APIRouter(
  prefix="/observation",  
)

db : SchemaManager = None

@router.lifespan("startup")
async def startup_event():
  global db
  db = await SchemaManager.init()


API_KEY = config.settings.ASTRO_OPEN_API_KEY
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
async def observation(
  type: str = Query(...), 
  startDate: str = Query(...), 
  endDate: str = Query(...)
  ):

  params = {
  "API_KEY" : API_KEY,
  "format" : "json",
  "startDate" : f"{startDate:02d%}",
  "endDate" : f"{endDate:02d%}",
  }

  # 하루치 데이터만 db에서 관리 : 날짜가 다르다면 db 삭제
  if(date.today() != await db.custom("SELECT date_log FROM ObservationDailyLog ORDER BY date_log DESC LIMIT 1")):
    try:
      await db.delete("ObservationDailyLog")
    except Exception as e:
      print(f"ObservationDailyLog db 삭제 오류 : {e}")


  # nasa api 호출 -> 변경 사항 발견 -> db 접근 -> db 중복 검사 -> db에서 마지막 요소 불러오기
  if(type == "solar"):
    async with httpx.AsyncClient() as client:
      try:
        response = await client.get(f"{NASA_URL}{API_PATH["notification"]}{params}")
        # 응답 -> db에서 중복 검색 -> 없다면 db 삽입(있으면 무시) 
        # 반환 : db에서 마지막으로 삽입한 요소를 반환
        # 조건에서 id로 중복을 탐색하고 중복이 없다면 삽입
        if(not(await db.select("ObservationDailyLog", "response.messageID"))):
          await db.insert("ObservationDailyLog", (
            response.messageID, 
            'solar', 
            date.now().strftime("%Y-%m-%d"),
            date.now().strftime("%H:%M"),
            response.messageType, # >> FLR 과같은 이벤트 타입 
            response.messageBody,
          ))
      except Exception as e:
        print(f"관측일지 에러 발생 : {e}")
        return {"error" : str(e)}
      
  elif(type == "earth"):
    async with httpx.AsyncClient() as client:
      try:
        response_GST = client.get(f"{NASA_URL}{API_PATH['GST']}{params}")
        params["location"] = "Earth"
        response_IPS = client.get(f"{NASA_URL}{API_PATH['IPS']}{params}")
        if(
          not(await db.select("ObservationDailyLog", "response_GST.gstID"))
          and not(await db.select("ObservationDailyLog", "response_GST.gstID"))
        ):
          await db.insert("ObservationDailyLog",(
            response_GST.gstID,
            'earth',
            date.now().strftime("%Y-%m-%d"),
            date.now().strftime("%H:%M"),
            "GST(전자기 폭풍) 발생",
            f"{response_GST.startTime}에 전자기 폭풍이 발생했습니다."
          ))
          await db.insert("ObservationDailyLog",(
            response_IPS.activityID,
            date.now().strftime("%Y-%m-%d"),
            date.now().strftime("%H:%M"),
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
  return await db.custom(f"SELECT * FROM ObservationDailyLog WHERE object_type={type};")

# 별 위치 가져오기
@router.get('/position')
def observation_star():
  return ''

