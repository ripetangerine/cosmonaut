from fastapi import FastAPI

# 라우트 
from app.routes.information import router as information, get_calender
from app.routes.observation import router as observation
from app.routes.whitenoise import router as whitenoise

router = FastAPI()
router.include_router(
  information,
  observation,
  whitenoise,
)

@router.get("/")
async def bootstrap():
  calender = await get_calender()
  return {
    "calender" : calender
  }