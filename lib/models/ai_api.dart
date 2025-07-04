import 'package:hive/hive.dart';

part 'ai_api.g.dart';

/// AiApi 配置表
@HiveType(typeId: 0)
class AiApi extends HiveObject {
  /// 主键ID
  @HiveField(0)
  late int id = 0;

  /// 服务名称
  @HiveField(1)
  late String serviceName;

  /// 服务提供商
  @HiveField(2)
  late String provider;

  /// 基础URL地址
  @HiveField(3)
  late String baseUrl;

  /// API密钥
  @HiveField(4)
  late String apiKey;

  /// 模型列表 (多个模型以逗号分隔)
  @HiveField(5)
  late String models;

  /// 是否激活 (默认激活)
  @HiveField(6)
  late bool isActive = true;

  /// 创建时间
  @HiveField(7)
  late DateTime createTime = DateTime.now();

  /// 更新时间
  @HiveField(8)
  late DateTime updateTime = DateTime.now();
}
