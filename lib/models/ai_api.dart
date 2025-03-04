import 'package:drift/drift.dart';

/// AiApi 配置表
class AiApi extends Table {
  /// 主键ID
  late final id = integer().autoIncrement()();

  /// 服务名称
  late final serviceName = text()();

  /// 服务提供商
  late final provider = text()();

  /// 服务类型
  late final serviceType = text()();

  /// 基础URL地址
  late final baseUrl = text()();

  /// API密钥
  late final apiKey = text()();

  /// 模型名称
  late final modelName = text()();

  /// 模型配置(JSON格式)
  late final modelConfig = text()();

  /// 是否激活(1:激活 0:未激活)
  late final isActive = integer().withDefault(const Constant(1))();

  /// 创建时间
  late final createdTime = dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  late final updatedTime = dateTime().withDefault(currentDateAndTime)();
}
