import 'package:ai_client/models/ai_api.dart';
import 'package:dio/dio.dart';

class ChatHttp {
  final Dio dio;

  ChatHttp(this.dio);

  /// 发送聊天请求
  ///
  /// [api]：包含所有必要 API 信息的 AIApi 实体。
  /// [message]：用户发送的消息内容，会包装进 OpenAI 要求的请求体中。
  Future<Response> sendChatRequest({
    required AIApi api,
    required String message,
  }) async {
    // 检查 baseUrl 是否存在
    if (api.baseUrl == null || api.baseUrl!.isEmpty) {
      throw ArgumentError('API 的 baseUrl 不能为空或为 null');
    }

    // 设置请求头, 根据 OpenAI 的要求通常为 Bearer Token
    dio.options.headers['Authorization'] = 'Bearer ${api.apiKey}';

    // 构造符合 OpenAI 格式的请求体
    final requestBody = {
      'model': api.modelName ?? 'gpt-3.5-turbo',
      'messages': [
        {
          'role': 'user',
          'content': message,
        }
      ],
      'max_tokens': api.maxTokens,
      'temperature': api.temperature,
    };

    try {
      // 发送 POST 请求到 API 的 baseUrl
      final response = await dio.post(
        api.baseUrl!,
        data: requestBody,
      );
      return response;
    } catch (e) {
      print('请求异常：$e');
      rethrow;
    }
  }
}
