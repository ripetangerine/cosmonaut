from fastapi import FastAPI, Query
from fastapi.encoders import jsonable_encoder
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime

# 라우트 
# from app.routes.information import router as information, get_calender
# from app.routes.observation import router as observation, get_observation, star_position
# from app.routes.whitenoise import router as whitenoise, get_whitenoise

from app.routes import observation, information, whitenoise
from app.routes.information import get_calender
from app.routes.observation import get_observation, star_position
from app.routes.whitenoise import get_whitenoise


app = FastAPI()

app.include_router(observation.router, prefix='/observation')
app.include_router(information.router, prefix='/information')
app.include_router(whitenoise.router, prefix='/whitenoise')

origins = [
  "http://localhost:8080",
]

app.add_middleware(
  CORSMiddleware,
  allow_origins=origins,
  allow_credentials=True,
  allow_method=["*"],
  allow_headers=["*"]
)

class BootRes(BaseModel):
  calender : list
  observation : list
  whitenoise: list


@app.get("/", response_model=BootRes)
async def bootstrap(
  type: str = Query(...)
):
  current = datetime.now()
  calender = await get_calender(current.year(), current.month())
  observation = await get_observation(type, current.day(), current.day())
  whitenoise = await get_whitenoise()
  starPosition = await star_position()

  res = {
    "calender" : calender,
    "observation" : observation,
    "whitenoise" : whitenoise,
  }
  return jsonable_encoder(res)
  
