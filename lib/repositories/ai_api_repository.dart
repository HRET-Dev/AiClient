import 'package:ai_client/models/ai_api.dart';
import 'package:ai_client/services/hive_storage_service.dart';
import 'package:hive/hive.dart';

/// AiApi 数据访问对象
class AiApiRepository {
  /// AiApi数据盒子
  final Box<AiApi> _aiApiBox = HiveStorageService.aiApiBox;

  // 构造函数
  AiApiRepository();

  /// 获取所有AI API记录
  /// 返回AI API列表
  List<AiApi> getAllAiApis() {
    return _aiApiBox.values.where((api) => api.isActive).toList();
  }

  /// 获取所有启用的AI API记录
  /// 1:激活 0:未激活
  /// 返回启用的AI API列表
  List<AiApi> getAllActiveAiApis() {
    return _aiApiBox.values.where((api) => api.isActive == true).toList();
  }

  /// 根据ID获取单个AI API
  ///
  /// [id] AI API ID
  /// 返回单个AI API对象
  AiApi? getAiApiById(int id) {
    return _aiApiBox.values.where((api) => api.id == id).firstOrNull;
  }

  /// 插入AI API记录
  ///
  /// [aiApi] AI API对象
  /// 返回插入的记录ID
  Future<int> insertAiApi(AiApi aiApi) async {
    // 添加记录并接收自动生成的Key
    final key = await _aiApiBox.add(aiApi);
    // 将自动生成的 key 作为 id 写回
    aiApi.id = key;
    // 保存记录
    await aiApi.save();
    // 返回id
    return key;
  }

  /// 批量插入AI API记录
  ///
  /// [aiApis] AI API列表
  Future<void> insertAiApis(List<AiApi> apis) async {
    final List<int> keys = (await _aiApiBox.addAll(apis)).toList();
    // 写回每个对象的 id，并保存
    for (var i = 0; i < apis.length; i++) {
      apis[i].id = keys[i];
      await apis[i].save();
    }
  }

  /// 更新AI API记录
  ///
  /// [aiApi] AI API对象
  Future<void> updateAiApi(AiApi aiApi) async {
    await aiApi.save();
  }

  /// 删除AI API记录
  ///
  /// [id] AI API ID
  Future<void> deleteAiApi(int id) async {
    await _aiApiBox.delete(id);
  }
}
