import 'dart:math';

import 'package:ai_client/database/app_database.dart';
import 'package:drift/drift.dart';
import 'dart:convert';

/// API 配置类
class DefaultApiConfigs {
  // 目前支持的API 提供商类型
  static const List<String> supportedApiProviders = [
    'OpenAI',
    'Ollama',
    'Azure',
    'Anthropic',
    'Gemini',
  ];

  /// API服务商基础配置
  /// 目前支持：
  /// - OpenAI（使用相对路径）
  /// - Ollama（使用相对路径）
  /// - Azure（使用相对路径）
  /// - Anthropic（使用相对路径）
  /// - Gemini（使用相对路径）
  /// 后续会支持更多的模型服务商
  static const Map<String, Map<String, String>> apiEndpoints = {
    'OpenAI': {
      'baseUrl': 'https://api.openai.com',
      'chatCompletion': 'v1/chat/completions',
      'imageGeneration': 'v1/images/generations',
      'modelList': 'v1/models',
    },
    'Ollama': {
      'baseUrl': 'http://127.0.0.1:11434',
      'chatCompletion': 'v1/chat/completions',
      'imageGeneration': 'v1/images/generations',
      'modelList': 'v1/models',
    },
    'Azure': {
      'baseUrl': 'https://{instance}.openai.azure.com',
      'chatCompletion':
          'openai/deployments/{deployment}/chat/completions?api-version={api-version}',
    },
    'Anthropic': {
      'baseUrl': 'https://api.anthropic.com',
      'chatCompletion': 'v1/messages',
    },
    'Gemini': {
      'baseUrl': 'https://generativelanguage.googleapis.com',
      'chatCompletion': 'v1beta/models/{model}:generateContent',
    },
  };

  /// API 服务商认证配置
  static const Map<String, Map<String, dynamic>> authConfigs = {
    'OpenAI': {
      'type': 'bearer',
    },
    'Ollama': {
      'type': 'bearer',
    },
    'Azure': {
      'type': 'api-key',
      'header': 'api-key',
    },
    'Anthropic': {
      'type': 'custom',
      'header': 'x-api-key',
      'format': '{0}',
      'additionalHeaders': {
        'anthropic-version': '2023-06-01',
      },
    },
    'Gemini': {
      'type': 'custom',
      'header': 'x-goog-api-key',
      'format': '{0}',
    },
  };

  /// 获取服务商的认证配置
  ///
  /// [provider] 服务商名称
  /// 返回认证配置信息
  static Map<String, dynamic> getAuthConfig(String provider) {
    return authConfigs[provider] ?? {'type': 'bearer'};
  }

  /// 生成随机字符串
  static String _generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(List.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  /// 默认模型配置 API 配置列表
  static List<AiApiCompanion> defaultApiConfig() {
    return [
      AiApiCompanion(
        serviceName: const Value('默认配置'),
        provider: const Value('OpenAI'),
        baseUrl: const Value('https://free.zeroai.chat'),
        apiKey: Value(_generateRandomString(32)),
        models: const Value('gpt-4o'),
        isActive: const Value(true),
        createdTime: Value(DateTime.now()),
        updatedTime: Value(DateTime.now()),
      ),
    ];
  }

  /// 获取完整API路径的通用方法
  /// [provider] 服务商名称
  /// [endpointKey] 端点类型的键值 (chatCompletion/imageGeneration 等)
  /// [customBaseUrl] 自定义的API服务地址，如果为空则使用默认的API服务地址
  static String getApiUrl(
      String provider, String endpointKey, String? customBaseUrl) {
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

  /// 获取模型列表的API路径
  ///
  /// [provider] 服务商名称
  /// [baseUrl] API服务地址
  /// [apiKey] API Key
  /// 返回模型列表的API路径
  static String getModelListUrl(
      String provider, String baseUrl, String apiKey) {
    if (baseUrl.isEmpty) {
      throw Exception('API 的 baseUrl 不能为空或为 null');
    }

    final endpointKey = 'modelList';
    return getApiUrl(provider, endpointKey, baseUrl);
  }

  /// 根据服务商配置认证头信息
  ///
  /// [headers]：请求头字典
  /// [api]：API 配置信息
  static void configureAuthHeaders(
      Map<String, dynamic> headers, String provider, String apiKey) {
    // 获取服务商的认证配置
    final authConfig = DefaultApiConfigs.getAuthConfig(provider);

    // 根据认证类型配置请求头
    switch (authConfig['type']) {
      case 'bearer':
        headers['Authorization'] = 'Bearer $apiKey';
        break;
      case 'api-key':
        headers[authConfig['header'] ?? 'x-api-key'] = apiKey;
        break;
      case 'basic':
        final credentials = '${authConfig['username'] ?? ''}:$apiKey';
        final encodedCredentials = base64Encode(utf8.encode(credentials));
        headers['Authorization'] = 'Basic $encodedCredentials';
        break;
      case 'custom':
        // 自定义头部处理
        final headerName = authConfig['header'] ?? 'Authorization';
        final headerFormat = authConfig['format'] ?? '{0}';
        headers[headerName] = headerFormat.replaceAll('{0}', apiKey);
        break;
      default:
        // 默认使用 Bearer 认证
        headers['Authorization'] = 'Bearer $apiKey';
        break;
    }

    // 添加其他可能的固定头信息
    if (authConfig.containsKey('additionalHeaders')) {
      final additionalHeaders =
          authConfig['additionalHeaders'] as Map<String, String>?;
      if (additionalHeaders != null) {
        headers.addAll(additionalHeaders);
      }
    }
  }
}
