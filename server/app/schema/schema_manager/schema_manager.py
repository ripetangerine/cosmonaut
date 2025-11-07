import sqlite3 
import os


# 의존성 DB 관리 클래스
# sqlite가 성능이 별로라면 aiosqlite로 변경


class SchemaManager:
  def __init__(self):
    self.rootPath = "./data/"
    self.file_name = "test.db" 
    self.connection = sqlite3.connect(f'{self.root}{self.file_name}')
    self.cursor = self.connection.cursor


  def default(self):
    self.cursor.execute(self.path)

  def create_table(self, query):
    self.cursor.execute(query)

  def insert(self, value):
    insert_query = "INSERT INTO users (name, age) VALUES (?, ?);"
    element = value
    self.cursor.execute(insert_query, element)

  def select(self, table, condition):
    select_query = "SELECT FROM ? WHERE id=?"
    self.cursor.execute(select_query, table, condition)

  def save(self):
    self.connection.commit()
    self.connection.close()

  def __del__(self):
    self.save()
    print(f"schema manager 인스턴스 삭제 위치 : {os.path.basename(os.path.abspath(__file__))}")

