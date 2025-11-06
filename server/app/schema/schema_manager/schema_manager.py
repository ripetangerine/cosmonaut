import sqlite3 
import os


# 의존성 DB 관리 클래스

class SchemaManager:
  def __init__(self):
    self.root = "./data/"
    self.file_name = "test.db" 
    self.connection = sqlite3.connect(f'{self.root}{self.file_name}')
    self.cursor = self.connection.cursor


  def default(self):
    self.cursor.execute(self.path)

  def createTable(self, query):
    self.cursor.execute(query)


  def insert(self, value):
    insert_command = "INSERT INTO users (name, age) VALUES (?, ?);"
    user = value
    self.cursor.execute(insert_command, user)

  def save(self):
    self.connection.commit()
    self.connection.close()

  def __del__(self):
    self.save()
    print(f"schema manager 인스턴스 삭제 위치 : {os.path.basename(os.path.abspath(__file__))}")

