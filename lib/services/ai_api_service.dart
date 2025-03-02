import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/default_api_configs.dart';
import 'package:ai_client/repositories/ai_api__repository.dart';
import 'package:drift/drift.dart';
import 'dart:developer' as developer;

/// AiApi服务类
class AiApiService {
  // AiApiRepository实例
  final AiApiRepository aiApiRepository;

  // 构造函数
  AiApiService(this.aiApiRepository);

  /// 初始化AiApi默认配置
  /// 返回AI API列表
  Future<List<AiApiData>> initDefaultAiApiConfig() async {
    // 查询数据
    var data = await getAllAiApis();
    // 判断是否有数据
    if (data.isEmpty) {
      // 获取默认配置信息
      final defaultApiConfig = DefaultApiConfigs.defaultApiConfig();
      // 添加默认数据到数据库
      insertAiApis(defaultApiConfig);
      // 重新查询数据
      data = await getAllAiApis();
    }
    // 返回数据
    return data;
  }

  /// 获取所有AI API记录
  /// 返回AI API列表
  Future<List<AiApiData>> getAllAiApis() async {
    try {
      // 调用数据层方法获取所有API记录
      return await aiApiRepository.getAllAiApis();
    } catch (e, stackTrace) {
      // 发生异常时记录错误日志并返回空列表
      developer.log('获取所有AI API失败', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// 获取所有启用的AI API记录
  /// 1:激活 0:未激活
  Future<List<AiApiData>> getAllActiveAiApis() async {
    try {
      // 调用数据层方法获取所有激活状态的API记录
      return await aiApiRepository.getAllActiveAiApis();
    } catch (e, stackTrace) {
      // 发生异常时记录错误日志并返回空列表
      developer.log('获取所有启用的AI API失败', error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// 根据ID获取AI API记录
  /// [id] AI API记录ID
  /// 返回AI API对象
  Future<AiApiData?> getAiApiById(int id) async {
    try {
      // 调用数据层方法根据ID查询API记录
      return await aiApiRepository.getAiApiById(id);
    } catch (e, stackTrace) {
      // 发生异常时记录错误日志并返回null
      developer.log('根据ID获取AI API失败: $id', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// 插入AI API记录
  /// [aiApi] AI API对象
  Future<bool> insertAiApi(AiApiCompanion aiApi) async {
    try {
      // 获取当前时间戳
      final now = DateTime.now();
      // 设置创建时间和更新时间
      aiApi = aiApi.copyWith(createdTime: Value(now), updatedTime: Value(now));
      // 调用数据层方法插入API记录
      await aiApiRepository.insertAiApi(aiApi);
      // 插入成功返回true
      return true;
    } catch (e, stackTrace) {
      // 发生异常时记录错误日志并返回false
      developer.log('插入AI API失败', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// 批量插入AI API记录
  /// [aiApis] AI API列表
  Future<bool> insertAiApis(List<AiApiCompanion> aiApis) async {
    try {
      // 获取当前时间戳
      final now = DateTime.now();
      // 为每条记录设置创建时间和更新时间
      aiApis = aiApis.map((aiApi) {
        return aiApi.copyWith(createdTime: Value(now), updatedTime: Value(now));
      }).toList();
      // 调用数据层方法批量插入API记录
      await aiApiRepository.insertAiApis(aiApis);
      // 插入成功返回true
      return true;
    } catch (e, stackTrace) {
      // 发生异常时记录错误日志并返回false
      developer.log('批量插入AI API失败', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// 更新AI API记录
  /// [aiApi] AI API对象
  Future<bool> updateAiApi(AiApiCompanion aiApi) async {
    try {
      // 获取当前时间戳
      final now = DateTime.now();
      // 更新记录的更新时间
      aiApi = aiApi.copyWith(updatedTime: Value(now));
      // 调用数据层方法更新API记录
      return await aiApiRepository.updateAiApi(aiApi);
    } catch (e, stackTrace) {
      // 发生异常时记录错误日志并返回false
      developer.log('更新AI API失败', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// 根据ID删除AI API记录
  /// [id] AI API记录ID
  /// 返回删除的记录数，失败返回0
  Future<int> deleteAiApiById(int id) async {
    try {
      // 调用数据层方法删除API记录
      return await aiApiRepository.deleteAiApi(id);
    } catch (e, stackTrace) {
      // 发生异常时记录错误日志并返回0
      developer.log('删除AI API失败: $id', error: e, stackTrace: stackTrace);
      return 0;
    }
  }
}
