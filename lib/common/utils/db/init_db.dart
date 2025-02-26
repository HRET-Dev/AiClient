// 导出表文件临时存放的文件夹
const DB_EXPORT_DIR = "db_export";
// 导出的表前缀
const DB_TABLE_PREFIX = "hret_";

class InitDb {
  // db 名称
  static String databaseName = "ai_client.db";

  // AI API 信息表结构
  static String createAIApiTable = '''
    CREATE TABLE IF NOT EXISTS ${DB_TABLE_PREFIX}ai_apis (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      serviceName TEXT NOT NULL CHECK(length(serviceName) <= 50),
      serviceType TEXT NOT NULL CHECK(serviceType IN ('TEXT_GEN', 'IMAGE_GEN', 'SPEECH_RECOG', 'OTHER')),
      baseUrl TEXT CHECK(length(baseUrl) <= 200),
      apiKey TEXT NOT NULL CHECK(length(apiKey) <= 200),
      modelName TEXT CHECK(length(modelName) <= 50),
      maxTokens INTEGER DEFAULT 1000,
      temperature REAL DEFAULT 1.0 CHECK(temperature BETWEEN 0.0 AND 2.0),
      isActive BOOLEAN DEFAULT 1,
      createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
      updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
      UNIQUE(serviceName, serviceType)
    );
    
    CREATE INDEX IF NOT EXISTS idx_service_type 
    ON ${DB_TABLE_PREFIX}ai_apis (serviceType);
    
    CREATE INDEX IF NOT EXISTS idx_active_apis
    ON ${DB_TABLE_PREFIX}ai_apis (isActive);
  ''';

  // 数据库升级逻辑（可根据版本迭代扩展）
  static List<String> upgradeQueries(int oldVersion, int newVersion) {
    final queries = <String>[];
    if (oldVersion < 1) {
      queries.add(createAIApiTable);
    }
    // 后续版本升级在此添加
    return queries;
  }
}
