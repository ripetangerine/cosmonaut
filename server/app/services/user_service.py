from sqlalchemy.orm import Session
from app.models.user_model import User
from app.schemas.user_schema import UserCreate
from app.utils.jwt_handler import create_access_token
from passlib.hash import bcrypt


# TODO : 추후 서비스 분리
# 예시


def create_user(db: Session, user: UserCreate):
    hashed_pw = bcrypt.hash(user.password)
    new_user = User(username=user.username, password=hashed_pw)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


def login_user(db: Session, username: str, password: str):
    user = db.query(User).filter(User.username == username).first()
    if user and bcrypt.verify(password, user.password):
        token = create_access_token({"sub": user.username})
        return {"access_token": token, "token_type": "bearer"}
    return None


