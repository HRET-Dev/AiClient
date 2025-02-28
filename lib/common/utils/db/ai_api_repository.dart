import 'package:ai_client/common/utils/db/database_helper.dart';
import 'package:ai_client/models/ai_api.dart';

// 定义 API 存取仓库，通过 DatabaseHelper 实现 API 信息的增删改查
class AIApiRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // 插入一条 AIApi 信息到数据库
  Future<int?> addAIApi(AIApi api) async {
    return await _dbHelper.insert(AIApi.tableName, api.toMap());
  }

  // 查询所有存储的 AIApi 信息
  Future<List<AIApi>> getAllAIApis() async {
    final List<Map<String, dynamic>> maps =
        await _dbHelper.query(AIApi.tableName);
    return maps.map((map) => AIApi.fromMap(map)).toList();
  }

  // 更新某条 AIApi 信息（依据 id 更新）
  Future<int> updateAIApi(AIApi api) async {
    if (api.id == null) {
      throw ArgumentError('AIApi 对象必须包含有效的 id 才能更新');
    }
    return await _dbHelper.update(
      AIApi.tableName,
      api.toMap(),
      where: 'id = ?',
      whereArgs: [api.id],
    );
  }

  // 删除某条 AIApi 信息（依据 id 删除）
  Future<int> deleteAIApi(int id) async {
    return await _dbHelper.delete(
      AIApi.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
