from fastapi import FastAPI
# from routers import users, auth, items

# app = FastAPI()

# @app.get("/")
# def read_root():
#     return {"message": "Hello FastAPI!"}



'''
from fastapi import FastAPI

app = FastAPI()

app.include_router(users.router, prefix="/api/v1/users", tags=["Users"])
app.include_router(auth.router, prefix="/api/v1/auth", tags=["Auth"])
app.include_router(items.router, prefix="/api/v1/items", tags=["Items"])


-------


# main.py
from fastapi import FastAPI
from routers import users, auth   # 라우터 임포트

app = FastAPI()

# 라우터 연결
app.include_router(users.router)
app.include_router(auth.router)  # 나중에 auth 라우터 추가 가능

'''