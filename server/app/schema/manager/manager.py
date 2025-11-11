import aiosqlite
import os

class Manager:
  def __init__(self):
    self.db_path = "./data/test.db"
    self.connect = None

  @classmethod
  async def init(cls):
    self = cls()
    self.connect = await aiosqlite.connect(f'{self.db_path}')
    return self
    
  async def create_table(self, query):
    async with self.connect.cursor() as cursor:
      await cursor.execute(query)
    await self.connect.commit()

  async def insert(self, table, value): # 이중으로 삽입 -> ("table", ("값1, 값2..."))
    # TODO : 테이블 부분 쿼리 수정 필요
    
    query = f"INSERT INTO {table} (name, age) VALUES (?, ?);"
    async with self.connect.cursor() as cursor:
      await cursor.execute(query, value)
    await self.connect.commit()

  async def select(self, table, id):
    if(id == None):
      query = f"SELECT * FROM {table}"
    else:
      query = f"SELECT * FROM {table} WHERE id=?"
    async with self.connect.cursor() as cursor:
      try:
        await cursor.execute(query, (id, ))
      except Exception:
        return False
      answer = await cursor.fetchone()
    return answer
  
  async def custom(self, query):
    async with self.connect.cursor() as cursor:
      await cursor.execute(query)
      return await cursor.fetchone()
    
  async def delete(self, table):
    query = f"TRUNCATE TABLE {table};"
    async with self.connect.cursor() as cursor:
      await cursor.execute(query)

  async def save(self):
    await self.connection.commit()
    await self.connection.close()

  def __del__(self):
    print(f"[SchemaManager] 인스턴스 삭제 시 현위치: {os.path.basename(self.db_path)}")
