from fastapi import APIRouter
import httpx
import random 
import datetime
import mars_time
import schema.schema_manager.schema_manager as schama_manager
import config

schamaManager = schama_manager.SchemaManager()

# TODO : 천체 정보 추가 이후, 랜덤처리 추가

router = APIRouter(
  prefix="object"
)

# 천문 현상 정보 랜덤 반환
# 월 단위 
@router.get('/calender')
async def calender():
  URL = "http://apis.data.go.kr/B090041/openapi/service/AstroEventInfoService/getAstroEventInfo"
  API_KEY = config.settings.ASTRO_OPEN_API_KEY
  params = {
    "api_key" : f"{API_KEY}",
    "format" : "json",
  }
  async with httpx.AsyncClient() as client:
    try:
      response = await client.get(API_KEY, params=params, timeout=5.0)
      response.raise_for_status()
      return response.json()
    
    except httpx.HTTPStatusError as e:
      print(f"calender API 요청 실패: 상태 코드 {e.response.status_code} for {e.request.url}")
      return {"error": f"calender API에서 오류 응답을 받았습니다: {e.response.status_code}"}

    except httpx.RequestError as e:
      # 네트워크, 타임아웃
      print(f"API 요청 중 오류 발생: {e.request.url} - {e}")
      return {"error": "화성 날짜를 불러올 수 없습니다."}


@router.get('/mars')
def marsInfo():
  try:
    data = schamaManager.select("Mars", random.randrange(1, 2))
  except Exception as e:
    print(f"화성 정보 불러오기 에러 : {e}")
  return data


@router.get('/mars/date')
def marsDate():
  now = datetime.now()
  mars = mars_time.datetime_to_marstime(now.year, now.month, now.day)
  sol = ".0f".format(mars.sol)
  return sol


@router.get('/solar')
def solarInfo():
  try:
    data = schamaManager.select("Solar", random.randrange(1, 2))
  except Exception as e:
    print(f"태양 정보 불러 오기 에러 : {e}")
  return data


@router.get('/earth')
def earthInfo():
  try:
    data = schamaManager.select("Earth", random.randrange(1, 2))
  except Exception as e:
    print(f"지구 정보 불러오기 에러 : {e}")
  return data

