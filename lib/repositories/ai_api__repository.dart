import 'package:ai_client/database/app_database.dart';
import 'package:drift/drift.dart';

/// AiApi 数据访问对象
class AiApiRepository {

  /// 数据库实例
  final AppDatabase database;

  // 构造函数
  AiApiRepository(this.database);

  /// 获取所有AI API记录
  /// 返回AI API列表
  Future<List<AiApiData>> getAllAiApis() {
    return database.select(database.aiApi).get();
  }

  /// 获取所有启用的AI API记录
  /// 1:激活 0:未激活
  /// 返回启用的AI API列表
  Future<List<AiApiData>> getAllActiveAiApis() {
    return (database.select(database.aiApi)
     ..where((t) => t.isActive.equals(1)))
     .get();
  }
  
  /// 根据ID获取单个AI API
  /// 
  /// [id] AI API ID
  /// 返回单个AI API对象
  Future<AiApiData?> getAiApiById(int id) {
    return (database.select(database.aiApi)
      ..where((t) => t.id.equals(id)))
      .getSingleOrNull();
  }

  /// 插入AI API记录
  /// 
  /// [aiApi] AI API对象
  /// 返回插入的记录ID
  Future<int> insertAiApi(Insertable<AiApiData> aiApi) {
    return database.into(database.aiApi).insert(aiApi);
  }

  /// 批量插入AI API记录
  /// 
  /// [aiApis] AI API列表
  Future<void> insertAiApis(List<Insertable<AiApiData>> aiApis) {
    return database.batch((batch) {
      batch.insertAll(database.aiApi, aiApis);
    });
  }
  
  /// 更新AI API记录
  /// 
  /// [aiApi] AI API对象
  /// 返回更新是否成功
  Future<bool> updateAiApi(Insertable<AiApiData> aiApi) {
    return database.update(database.aiApi).replace(aiApi);
  }
  
  /// 删除AI API记录
  /// 
  /// [id] AI API ID
  /// 返回删除的记录数量
  Future<int> deleteAiApi(int id) {
    return (database.delete(database.aiApi)
      ..where((t) => t.id.equals(id)))
      .go();
  }
}