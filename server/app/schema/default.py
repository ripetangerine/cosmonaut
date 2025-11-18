import asyncio
import manager.manager as SchemaManager

async def main():
  
  db = await SchemaManager.Manager.init()

  # 기본 테이블 생성 쿼리문
  query = [
    """
    CREATE TABLE test (
      col1 INTEGER PRIMARY KEY AUTOINCREMENT,
      col2 VARCHAR(200) NOT NULL,
      col3 TEXT default ""
    );
    """,
    """
    CREATE TABLE User(
      id INT AUTO_INCREMENT PRIMARY KEY,
      latest_page ENUM('solar', 'earth', 'mars', 'calender'),
      latest_noise TEXT,
      user_location TEXT,
    );
    """,
    """
    -- 행성 랜덤 정보
    CREATE TABLE Solar (
      id INT AUTO_INCREMENT PRIMARY KEY,
      content TEXT
    );
    """,
    """
    CREATE TABLE Earth (
      id INT AUTO_INCREMENT PRIMARY KEY,
      content TEXT
    );
    """,
    """
    CREATE TABLE Mars (
      id INT AUTO_INCREMENT PRIMARY KEY,
      content TEXT
    );
    """,
    """
    -- 관찰일지에서 하루 단위의 정보
    CREATE TABLE ObservationDailyLog (
      id TEXT PRIMARY KEY,
      object_type ENUM('solar', 'earth', 'mars'),
      timeStamp date not null,
      event_title TEXT not null,
      content TEXT not null,
    );
    """,
    """
    -- 천문 달력 정보
    CREATE TABLE AstroEvent (
      id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(255),
      `date` DATETIME,
      period VARCHAR(255),
      content TEXT,
    );
    """,
    """
    -- WhiteNoise 테이블 생성
    CREATE TABLE WhiteNoise (
      id INT PRIMARY KEY,
      path VARCHAR(255),
      title VARCHAR(255)
    );
    """,
    """
    CREATE TABLE calender(
      month INT PRIMARY KEY,
      event_day INT NOT NULL,
      event_title TEXT NOT NULL,
      event_content TEXT NOT NULL,
      event_time TEXT,
      seq_num INT,
    );
    """
  ]

  for q in query:
    print("실행 쿼리 :  " + q)
    await db.create_table(q)   

  # 3.DB 세이브 
  await db.save()


if __name__ == "__main__":
  asyncio.run(main())