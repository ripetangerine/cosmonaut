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
  )
    
    """

schemaManager.createTable(query_createTable)
schemaManager.save()
