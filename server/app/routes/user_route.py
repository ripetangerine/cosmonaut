from fastapi import APIRouter, Depends, HTTPException

router = APIRouter(prefix="/users", tags=["User"])


'''
from fastapi import APIRouter, Depends
from schemas.user import UserCreate, UserRead

router = APIRouter()

@router.post("/", response_model=UserRead)
def create_user(user: UserCreate):
    return {"msg": f"{user.name} created"}

@router.get("/{user_id}", response_model=UserRead)
def get_user(user_id: int):
    return {"user_id": user_id, "name": "Alice"}
'''

# TODO : 마운트 시 유저정보 자동 저장 및 가져오기
# TODO : 관측 일지를 유저 정보로 저장

            


# DB 세션 종속성
# def get_db():
#     db = SessionLocal()
#     try:
#         yield db
#     finally:
#         db.close()


# @router.post("/register")
# def register_user(user: UserCreate, db: Session = Depends(get_db)):
#     new_user = user_service.create_user(db, user)
#     return {"message": f"{new_user.username}님 회원가입 완료"}



# @router.post("/login")
# def login_user(user: UserLogin, db: Session = Depends(get_db)):
#     result = user_service.login_user(db, user.username, user.password)
#     if not result:
#         raise HTTPException(status_code=401, detail="로그인 실패")
#     return result
