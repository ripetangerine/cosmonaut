from contextlib import asynccontextmanager
from fastapi import FastAPI, Query
from fastapi.encoders import jsonable_encoder
from fastapi.middleware.cors import CORSMiddleware
# from pydantic import BaseModel
from datetime import datetime

# 라우트 
# from app.routes.information import router as information, get_calender
# from app.routes.observation import router as observation, get_observation, star_position
# from app.routes.whitenoise import router as whitenoise, get_whitenoise

from app.routes import observation, information, whitenoise
from app.routes.information import get_calender
from app.routes.observation import get_observation, star_position
from app.routes.whitenoise import get_whitenoise


@asynccontextmanager
async def combined_lifespan(app: FastAPI):
  async with observation.lifespan():
    async with information.lifespan():
      yield 

app = FastAPI(
  lifespan=combined_lifespan
)

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
  allow_methods=["*"],
  allow_headers=["*"]
)


@app.get("/")
async def bootstrap(
  type: str = Query("solar")
):
  current = datetime.now()
  day = current.day
  year = current.year
  month = current.month
  calender_data = await get_calender(year, month)
  observation_data = await get_observation(type, day, day)
  whitenoise_data = await get_whitenoise()
  starposition_data = await star_position()

  res = {
    "calender" : calender_data,
    "observation" : observation_data,
    "whitenoise" : whitenoise_data,
    "starposition" : starposition_data,
  }
  return jsonable_encoder(res)
  
