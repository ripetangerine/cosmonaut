from fastapi import APIRouter, HTTPException, Query
from fastapi.responses import StreamingResponse
import os

router = APIRouter(
  prefix="whitenoise"
)

AUDIO_ROOT_PATH = "../public/audio"
AUDIO_FILE_LIST = os.listdir('../public/audio')

try:
  AUDIO_FILE_LIST = os.listdir(AUDIO_ROOT_PATH)
except FileNotFoundError:
  # 기본 파일 삽입
  AUDIO_FILE_LIST = ['603921main_voyager_jupiter_lightning.mp3']


# 음악 리스트 반환
@router.get("/")
def init():
  return AUDIO_FILE_LIST

# 클라이언트에서 음악 파일명을 전송하면 해당 파일을 반환하는 방식
# 음악 실행 
@router.get('/play')
def play(
  noise_title: str = Query(...)
):
  try:
    if noise_title not in AUDIO_FILE_LIST:
      raise HTTPException(
        status_code = 404,
        detail = f"{noise_title} 파일을 찾을 수 없다."
      )
    file_path = os.path.join(AUDIO_ROOT_PATH, noise_title)
    headers ={
      "Content-Disposition" : f"attachment; filename={noise_title}"
    }

    return StreamingResponse(
      file_iterator(file_path),
      media_type="audio/mpeg",
      headers= headers
    )
  except HTTPException:
    raise

  except Exception as e:
    print(f"노이즈 실행 중 발생한 오류 : {e}")
    raise HTTPException(
      status_code=500,
      detail="서버 오류"
    )
  
def file_iterator(file_path: str):
  try:
    with open(file_path, mode="rb") as file_like:
      yield from file_like
    
  except Exception as e:
    print(f" 파일 이터레이터 오류 : {e}")


