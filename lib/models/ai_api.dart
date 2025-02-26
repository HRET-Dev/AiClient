class AIApi {
  static String tableName = 'ai_apis';

  final int? id;
  final String serviceName;
  final String serviceType;
  final String? baseUrl;
  final String apiKey;
  final String? modelName;
  final int maxTokens;
  final double temperature;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AIApi({
    this.id,
    required this.serviceName,
    required this.serviceType,
    this.baseUrl,
    required this.apiKey,
    this.modelName,
    this.maxTokens = 1000,
    this.temperature = 1.0,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now().toUtc(),
        updatedAt = updatedAt ?? DateTime.now().toUtc(),
        assert(maxTokens > 0, 'Max tokens must be positive'),
        assert(temperature >= 0.0 && temperature <= 2.0,
            'Temperature must be between 0.0 and 2.0') {
    _validateServiceType();
  }

  // 校验服务类型
  void _validateServiceType() {
    const validTypes = {'TEXT_GEN', 'IMAGE_GEN', 'SPEECH_RECOG', 'OTHER'};
    if (!validTypes.contains(serviceType)) {
      throw ArgumentError('Invalid service type: $serviceType');
    }
  }

  // 转换为数据库存储格式
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceName': serviceName,
      'serviceType': serviceType,
      'baseUrl': baseUrl,
      'apiKey': apiKey,
      'modelName': modelName,
      'maxTokens': maxTokens,
      'temperature': temperature,
      'isActive': isActive ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AIApi.fromJson(Map<String, dynamic> json) => AIApi.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIApi &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          serviceName == other.serviceName;

  @override
  int get hashCode => id.hashCode ^ serviceName.hashCode;

  // 从数据库查询结果创建实例
  factory AIApi.fromMap(Map<String, dynamic> map) {
    return AIApi(
      id: map['id'] as int?,
      serviceName: map['serviceName'] as String,
      serviceType: map['serviceType'] as String,
      baseUrl: map['baseUrl'] as String?,
      apiKey: map['apiKey'] as String,
      modelName: map['modelName'] as String?,
      maxTokens: map['maxTokens'] as int? ?? 1000,
      temperature: (map['temperature'] as num?)?.toDouble() ?? 1.0,
      isActive: (map['isActive'] as int?) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  // 更新操作方法
  AIApi copyWith({
    String? serviceName,
    String? serviceType,
    String? baseUrl,
    String? apiKey,
    String? modelName,
    int? maxTokens,
    double? temperature,
    bool? isActive,
  }) {
    return AIApi(
      id: id,
      serviceName: serviceName ?? this.serviceName,
      serviceType: serviceType ?? this.serviceType,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      modelName: modelName ?? this.modelName,
      maxTokens: maxTokens ?? this.maxTokens,
      temperature: temperature ?? this.temperature,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  @override
  String toString() {
    return 'AIApi('
        'id: $id, '
        'serviceName: $serviceName, '
        'model: $modelName, '
        'isActive: $isActive'
        ')';
  }
}
