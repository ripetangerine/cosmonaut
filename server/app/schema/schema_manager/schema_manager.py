import sqlite3 
import os

# 예시 
connection = sqlite3.connect('./test.db')
# connection = sqlite3.connect(':memory:')
cursor = connection.cursor
sql_default_command = """
  CREATE TABLE customer (
    CustomerID int,
    LastName varchar(255),
    FirstName varchar(255))
"""

# 의존성 DB 관리 클래스

class SchemaManager:
  def __init__(self):
    self.path = "./data/test.db"
    self.current_path = self.test_db_path # 현재 사용하고 있는 sql file path
    self.connection = sqlite3.connect(self.path)
    self.cursor = connection.cursor


  def default(self):
    self.cursor.execute(sql_default_command)

  def createTable(self, query):
    self.cursor.execute(query)


  def insert(self, value):
    insert_command = "INSERT INTO users (name, age) VALUES (?, ?);"
    # user = ('김유신', 25)
    user = value
    self.cursor.execute(insert_command, user)

  def save(self):
    self.connection.commit()
    self.connection.close()

  def __del__(self):
    self.save()
    print(f"schema manager 인스턴스 삭제 위치 : {os.path.basename(os.path.abspath(__file__))}")

