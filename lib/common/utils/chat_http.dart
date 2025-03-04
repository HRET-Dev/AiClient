import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/default_api_configs.dart';
import 'package:ai_client/models/chat_messages.dart';
import 'package:dio/dio.dart';

class ChatHttp {
  final Dio dio;

  ChatHttp(this.dio);

  /// 获取目标模型的列表
  /// 
  /// [baseUrl]：API 的 baseUrl
  /// [provider]：服务商名称
  /// [apiKey]：API Key
  Future<Response> getModelList({
    required String baseUrl,
    required String provider,
    required String apiKey,
  }) async {
    // 设置请求头，根据服务商类型动态配置认证方式
    DefaultApiConfigs.configureAuthHeaders(dio.options.headers, provider, apiKey);
    // 处理服务商 请求地址
    final newBaseUrl = DefaultApiConfigs.getModelListUrl(provider, baseUrl, apiKey);
    try {
      // 发送 GET 请求到 API 的 baseUrl
      return await dio.get(newBaseUrl);
    } catch (e) {
      print('请求异常：$e');
      rethrow;
    }
  }

  /// 发送聊天请求
  ///
  /// [api]：包含所有必要 API 信息的 AIApi 实体
  /// [message]：用户发送的消息内容，会包装进 OpenAI 要求的请求体中
  /// [historys]：历史消息列表，用于上下文
  Future<Response> sendChatRequest({
    required AiApiData api,
    required String message,
    List<ChatMessage>? historys,
  }) async {
    // 检查 baseUrl 是否存在
    if (api.baseUrl.isEmpty) {
      throw ArgumentError('API 的 baseUrl 不能为空或为 null');
    }

    // 设置请求头，根据服务商类型动态配置认证方式
    DefaultApiConfigs.configureAuthHeaders(dio.options.headers, api.provider, api.apiKey);

    // 处理服务商 请求地址
    final baseUrl = DefaultApiConfigs.getApiUrl(api.provider, 'chatCompletion', api.baseUrl);

    // 构建消息列表
    List<Map<String, dynamic>> messages = [];

    // 处理历史消息
    if (historys != null && historys.isNotEmpty) {
        // 遍历历史消息列表
        for (var history in historys) {
            // 构建角色和内容的字典
            final roleContent = {
              'role': history.isUser ? 'user' : 'assistant',
              'content': history.content,
            };
            // 将角色和内容添加到请求体的 messages 列表中
            messages.add(roleContent);
          }
    }

    // 设置新消息
    messages.add({'role': 'user', 'content': message});

    // 构建请求体
    final requestBody = {
      'model': api.modelName,
      'messages': messages,
    };
    
    try {
      // 发送 POST 请求到 API 的 baseUrl
      final response = await dio.post(
        baseUrl,
        data: requestBody,
      );
      return response;
    } catch (e) {
      print('请求异常：$e');
      rethrow;
    }
  }
}
