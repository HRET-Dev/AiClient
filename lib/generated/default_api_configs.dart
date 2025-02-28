import '../models/ai_api.dart';

/// API 配置类
class DefaultApiConfigs {
  // 目前支持的API 提供商类型
  static const List<String> supportedApiProviders = [
    'OpenAI',
  ];

  // 目前支持的API 服务类型
  static const List<String> supportedApiTypes = [
    'TEXT_GEN',
  ];

  /// API服务商基础配置
  /// 目前支持：
  /// - OpenAI（使用相对路径）
  /// 后续会支持更多的模型服务商
  static const Map<String, Map<String, String>> apiEndpoints = {
    'OpenAI': {
      'baseUrl': 'https://api.openai.com',
      'chatCompletion': 'v1/chat/completions',
      'imageGeneration': 'v1/images/generations',
      'modelList': 'v1/models',
    },
  };

  /// 默认模型配置 API 配置列表
  static List<AIApi> defaultApiConfig = [
    AIApi(
      serviceName: '默认模型配置 OpenAI GPT-4o',
      provider: 'OpenAI',
      serviceType: 'TEXT_GEN',
      baseUrl: 'https://free.zeroai.chat/v1/chat/completions',
      apiKey: 'hret',
      modelName: 'gpt-4o',
    ),
  ];

  /// 获取完整API路径的通用方法
  /// [provider] 服务商名称
  /// [endpointKey] 端点类型的键值 (chatCompletion/imageGeneration 等)
  /// [customBaseUrl] 自定义的API服务地址，如果为空则使用默认的API服务地址
  static String getApiUrl(String provider, String endpointKey,
      {String? customBaseUrl}) {
    // 处理#结尾的直接返回
    if (customBaseUrl != null && customBaseUrl.endsWith('#')) {
      return customBaseUrl.substring(0, customBaseUrl.length - 1);
    }

    final config = apiEndpoints[provider];
    if (config == null) throw Exception('不支持的提供商: $provider');

    final path = config[endpointKey];
    if (path == null) throw Exception('无效的端点类型: $endpointKey');

    // 处理尾部斜杠情况
    String effectiveBaseUrl = customBaseUrl ?? config['baseUrl']!;
    if (effectiveBaseUrl.endsWith('/')) {
      final versionIndex = path.indexOf('/');
      if (versionIndex != -1) {
        effectiveBaseUrl += path.substring(versionIndex + 1);
      } else {
        effectiveBaseUrl += path;
      }
      return effectiveBaseUrl;
    }

    // 正常拼接
    return Uri.parse(effectiveBaseUrl).resolve(path).toString();
  }
}
