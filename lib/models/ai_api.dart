import 'package:drift/drift.dart';

/// AiApi 配置表
class AiApi extends Table {
  /// 主键ID
  late final id = integer().autoIncrement()();

  /// 服务名称
  late final serviceName = text()();

  /// 服务提供商
  late final provider = text()();

  /// 基础URL地址
  late final baseUrl = text()();

  /// API密钥
  late final apiKey = text()();

  /// 模型列表 (多个模型以逗号分隔)
  late final models = text()();

  /// 是否激活 (默认激活)
  late final isActive = boolean().withDefault(const Constant(true))();

  /// 创建时间
  late final createdTime = dateTime().withDefault(currentDateAndTime)();

  /// 更新时间
  late final updatedTime = dateTime().withDefault(currentDateAndTime)();
}
