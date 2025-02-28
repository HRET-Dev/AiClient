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
      id INTEGER PRIMARY KEY AUTOINCREMENT, -- 主键，自增
      serviceName TEXT NOT NULL CHECK(length(serviceName) <= 50), -- API 名称，最大长度50
      provider TEXT NOT NULL CHECK(provider IN ('OpenAI', 'Anthropic')), -- API 服务商，目前支持 OpenAI 和 Anthropic
      serviceType TEXT NOT NULL CHECK(serviceType IN ('TEXT_GEN', 'IMAGE_GEN', 'SPEECH_RECOG', 'OTHER')), -- API 类型，支持文本生成、图像生成、语音识别等
      baseUrl TEXT CHECK(length(baseUrl) <= 200), -- API 地址，最大长度200
      apiKey TEXT NOT NULL CHECK(length(apiKey) <= 200), -- API 密钥，最大长度200
      modelName TEXT CHECK(length(modelName) <= 50), -- 模型名称，最大长度50
      modelConfig TEXT, -- 模型配置，存储为 JSON 字符串
      isActive BOOLEAN DEFAULT 1, -- 是否启用，默认为启用状态
      createdAt DATETIME DEFAULT (strftime('%Y-%m-%dT%H:%M:%f+08:00', 'now')), -- 创建时间，默认为当前时间
      updatedAt DATETIME DEFAULT (strftime('%Y-%m-%dT%H:%M:%f+08:00', 'now')), -- 更新时间，默认为当前时间
      UNIQUE(serviceName, serviceType) -- 唯一约束，确保服务名称和类型的组合唯一
    );
  
    CREATE INDEX IF NOT EXISTS idx_service_type 
    ON ${DB_TABLE_PREFIX}ai_apis (serviceType); -- 创建服务类型索引
    
    CREATE INDEX IF NOT EXISTS idx_active_apis
    ON ${DB_TABLE_PREFIX}ai_apis (isActive); -- 创建是否启用索引
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
