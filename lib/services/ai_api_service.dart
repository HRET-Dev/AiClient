import 'package:ai_client/generated/default_api_configs.dart';
import 'package:ai_client/models/ai_api.dart';
import 'package:ai_client/repositories/ai_api_repository.dart';
import 'dart:developer' as developer;

/// AiApi服务类
class AiApiService {
  final AiApiRepository _repository = AiApiRepository();

  AiApiService();

  /// 初始化默认 API 配置，如果 Box 为空则写入默认数据并返回
  Future<List<AiApi>> initDefaultAiApiConfig() async {
    var data = _repository.getAllAiApis();
    if (data.isEmpty) {
      final defaults = DefaultApiConfigs.defaultApiConfig();
      await _repository.insertAiApis(defaults);
      data = _repository.getAllAiApis();
    }
    return data;
  }

  /// 获取所有 AI API 记录
  Future<List<AiApi>> getAllAiApis() async {
    try {
      return _repository.getAllAiApis();
    } catch (e, st) {
      developer.log('获取所有 AI API 失败', error: e, stackTrace: st);
      return [];
    }
  }

  /// 获取所有激活的 AI API 记录
  Future<List<AiApi>> getAllActiveAiApis() async {
    try {
      return _repository.getAllActiveAiApis();
    } catch (e, st) {
      developer.log('获取激活的 AI API 失败', error: e, stackTrace: st);
      return [];
    }
  }

  /// 根据 ID 获取 AI API
  Future<AiApi?> getAiApiById(int id) async {
    try {
      return _repository.getAiApiById(id);
    } catch (e, st) {
      developer.log('根据 ID 获取 AI API 失败: \$id', error: e, stackTrace: st);
      return null;
    }
  }

  /// 插入单个 AI API
  Future<bool> insertAiApi(AiApi api) async {
    try {
      final now = DateTime.now();
      api
        ..createTime = now
        ..updateTime = now;
      await _repository.insertAiApi(api);
      return true;
    } catch (e, st) {
      developer.log('插入 AI API 失败', error: e, stackTrace: st);
      return false;
    }
  }

  /// 批量插入 AI API
  Future<bool> insertAiApis(List<AiApi> apis) async {
    try {
      final now = DateTime.now();
      for (var api in apis) {
        api
          ..createTime = now
          ..updateTime = now;
      }
      await _repository.insertAiApis(apis);
      return true;
    } catch (e, st) {
      developer.log('批量插入 AI API 失败', error: e, stackTrace: st);
      return false;
    }
  }

  /// 更新已有的 AI API
  Future<bool> updateAiApi(AiApi api) async {
    try {
      api.updateTime = DateTime.now();
      await _repository.updateAiApi(api);
      return true;
    } catch (e, st) {
      developer.log('更新 AI API 失败', error: e, stackTrace: st);
      return false;
    }
  }

  /// 删除 AI API
  Future<bool> deleteAiApiById(int id) async {
    try {
      await _repository.deleteAiApi(id);
      return true;
    } catch (e, st) {
      developer.log('删除 AI API 失败: \$id', error: e, stackTrace: st);
      return false;
    }
  }
}
