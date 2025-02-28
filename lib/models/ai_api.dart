import 'dart:convert';

import '../generated/default_api_configs.dart';

class AIApi {
  static String tableName = 'ai_apis';

  /// API ID
  final int? id;

  /// API 名称
  final String serviceName;

  /// API 服务商 (e.g., 'OpenAI', 'Anthropic')
  final String provider;

  /// API 类型 (e.g., 'TEXT_GEN', 'IMAGE_GEN')
  final String serviceType;

  /// API 地址
  final String? baseUrl;

  /// API 密钥
  final String apiKey;

  /// 模型名称
  final String? modelName;

  /// 模型配置 (e.g., maxTokens, temperature)
  final Map<String, dynamic> modelConfig;

  /// 是否启用
  final bool isActive;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;

  AIApi({
    this.id,
    required this.serviceName,
    required this.provider,
    required this.serviceType,
    this.baseUrl,
    required this.apiKey,
    this.modelName,
    Map<String, dynamic>? modelConfig,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : modelConfig = modelConfig ?? {},
        createdAt = createdAt ?? DateTime.now().toUtc(),
        updatedAt = updatedAt ?? DateTime.now().toUtc() {
    _validateServiceType();
    _validateProvider();
  }

  /// 校验服务类型
  void _validateServiceType() {
    const validTypes = DefaultApiConfigs.supportedApiTypes;
    if (!validTypes.contains(serviceType)) {
      throw ArgumentError('无效的服务类型: $serviceType');
    }
  }

  /// 校验服务商
  void _validateProvider() {
    if (!DefaultApiConfigs.supportedApiProviders.contains(provider)) {
      throw ArgumentError('不支持的服务商: $provider');
    }
  }

  /// 获取完整 API URL
  String getApiUrl(String endpointKey) {
    return DefaultApiConfigs.getApiUrl(
      provider,
      endpointKey,
      customBaseUrl: baseUrl,
    );
  }

  /// 转换为数据库存储格式
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceName': serviceName,
      'provider': provider,
      'serviceType': serviceType,
      'baseUrl': baseUrl,
      'apiKey': apiKey,
      'modelName': modelName,
      // 将 Map 转换为 JSON 字符串
      'modelConfig': jsonEncode(modelConfig),
      // 显式转换为 int 类型确保类型安全
      'isActive': isActive ? 1 : 0,
      // 确保时间格式符合数据库要求
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 从 JSON 创建实例
  factory AIApi.fromJson(Map<String, dynamic> json) => AIApi.fromMap(json);

  /// 转换为 JSON
  Map<String, dynamic> toJson() => toMap();

  /// 从数据库查询结果创建实例
  factory AIApi.fromMap(Map<String, dynamic> map) {
    return AIApi(
      id: map['id'] as int?,
      serviceName: map['serviceName'] as String,
      provider: map['provider'] as String,
      serviceType: map['serviceType'] as String,
      baseUrl: map['baseUrl'] as String?,
      apiKey: map['apiKey'] as String,
      modelName: map['modelName'] as String?,
      modelConfig: map['modelConfig'] != null
          ? Map<String, dynamic>.from(jsonDecode(map['modelConfig']))
          : {},
      isActive: (map['isActive'] as int?) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  /// 更新操作方法
  AIApi copyWith({
    String? serviceName,
    String? provider,
    String? serviceType,
    String? baseUrl,
    String? apiKey,
    String? modelName,
    Map<String, dynamic>? modelConfig,
    bool? isActive,
  }) {
    return AIApi(
      id: id,
      serviceName: serviceName ?? this.serviceName,
      provider: provider ?? this.provider,
      serviceType: serviceType ?? this.serviceType,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      modelName: modelName ?? this.modelName,
      modelConfig: modelConfig ?? this.modelConfig,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIApi &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          serviceName == other.serviceName;

  @override
  int get hashCode => id.hashCode ^ serviceName.hashCode;

  @override
  String toString() {
    return 'AIApi('
        'id: $id, '
        'serviceName: $serviceName, '
        'provider: $provider, '
        'model: $modelName, '
        'isActive: $isActive'
        ')';
  }
}

/// 聊天消息 Model
class ChatMessage {
  final String content;
  final bool isUser;

  ChatMessage({required this.content, required this.isUser});
}
