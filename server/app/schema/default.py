# 추후 ORM 적용해서 변경할 계획입니다.

import app.schema.schema_manager.schema_manager as schema_manager


# 스키마 메니저 클래스 인스턴스
schemaManager =  schema_manager.SchemaManager()

# 1. 기본 테이블 생성
query_createTable = """
  CREATE TABLE test (
    col1 INTEGER PRIMARY KEY AUTOINCREMENT,
    col2 VARCHAR(200) NOT NULL,
    col3 TEXT default ""
  );

  CREATE TABLE User(
    id INT AUTO_INCREMENT PRIMARY KEY,
    latest_page ENUM('solar', 'earth', 'mars', 'calender'),
    latest_noise TEXT,
    user_location TEXT,
  );

  -- 행성 랜덤 정보
  CREATE TABLE Solar (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT
  );
  CREATE TABLE Earth (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT
  );
  CREATE TABLE Mars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT
  );

  -- 관찰일지에서 하루 단위의 정보
  CREATE TABLE ObservationDailyLog (
    id INT PRIMARY KEY,
    object_type ENUM('solar', 'earth', 'mars'),
    observation TEXT
  );

  -- 천문 달력 정보
  CREATE TABLE AstroEvent (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    `date` DATETIME,
    period VARCHAR(255),
    content TEXT,
  );

  -- WhiteNoise 테이블 생성
  CREATE TABLE WhiteNoise (
    id INT PRIMARY KEY,
    path VARCHAR(255),
    title VARCHAR(255)
  );

  """
schemaManager.create_table(query_createTable)


# 2. 정적인 정보 삽입 - 행성 랜덤 정보 
# 



# 3.DB 세이브 
schemaManager.save()