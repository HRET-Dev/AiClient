import 'dart:async';

import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/default_api_configs.dart';
import 'package:ai_client/models/chat_messages.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class ChatHttp {
  final dio = Dio(BaseOptions(
    // 请求连接超时时间
    connectTimeout: const Duration(seconds: 10),
    // 因为是流式响应，同时ai的回复响应速度也较久，固响应超时时间设置长些，此处设置为180秒
    receiveTimeout: const Duration(seconds: 180),
    // 设置请求头
    contentType: 'application/json; charset=utf-8',
  ));

  ChatHttp();

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
    DefaultApiConfigs.configureAuthHeaders(
        dio.options.headers, provider, apiKey);
    // 处理服务商 请求地址
    final newBaseUrl =
        DefaultApiConfigs.getModelListUrl(provider, baseUrl, apiKey);
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
  /// [model]：模型名称
  /// [message]：用户发送的消息内容，会包装进 OpenAI 要求的请求体中
  /// [historys]：历史消息列表，用于上下文
  Future<Response> sendChatRequest({
    required AiApiData api,
    required String model,
    required String message,
    List<ChatMessage>? historys,
  }) async {
    // 检查 baseUrl 是否存在
    if (api.baseUrl.isEmpty) {
      throw ArgumentError('API 的 baseUrl 不能为空或为 null');
    }

    // 设置请求头，根据服务商类型动态配置认证方式
    DefaultApiConfigs.configureAuthHeaders(
        dio.options.headers, api.provider, api.apiKey);

    // 处理服务商 请求地址
    final baseUrl = DefaultApiConfigs.getApiUrl(
        api.provider, 'chatCompletion', api.baseUrl);

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
      'model': model,
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

  /// 发送流式聊天请求，自动回退到非流式请求
  ///
  /// [api]：包含所有必要 API 信息的 AIApi 实体
  /// [model]：模型名称
  /// [message]：用户发送的消息内容
  /// [historys]：历史消息列表，用于上下文
  Future<Stream<String>> sendStreamChatRequest({
    required AiApiData api,
    required String model,
    required String message,
    List<ChatMessage>? historys,
  }) async {
    // 检查 baseUrl 是否存在
    if (api.baseUrl.isEmpty) {
      throw ArgumentError('API 的 baseUrl 不能为空或为 null');
    }

    // 设置请求头，根据服务商类型动态配置认证方式
    DefaultApiConfigs.configureAuthHeaders(
        dio.options.headers, api.provider, api.apiKey);

    // 处理服务商 请求地址
    final baseUrl = DefaultApiConfigs.getApiUrl(
        api.provider, 'chatCompletion', api.baseUrl);

    // 构建消息列表
    List<Map<String, dynamic>> messages = [];

    // 处理历史消息
    if (historys != null && historys.isNotEmpty) {
      for (var history in historys) {
        final roleContent = {
          'role': history.isUser ? 'user' : 'assistant',
          'content': history.content,
        };
        messages.add(roleContent);
      }
    }

    // 设置新消息
    messages.add({'role': 'user', 'content': message});

    // 构建请求体，添加stream参数
    final requestBody = {
      'model': model,
      'messages': messages,
      'stream': true, // 启用流式响应
    };

    try {
      // 尝试发送流式请求
      final response = await dio.post(
        baseUrl,
        data: requestBody,
        options: Options(
          responseType: ResponseType.stream, // 设置响应类型为流
        ),
      );

      // 处理流式响应
      final responseStream = response.data.stream;

      // 创建一个控制器来管理输出流
      final streamController = StreamController<String>();

      // 处理原始字节流
      responseStream.cast<List<int>>().listen(
        (List<int> data) {
          // 解码字节数据
          final String text = utf8.decode(data);
          // 按行分割
          final List<String> lines = text.split('\n');

          for (var line in lines) {
            if (line.isEmpty || line == '[DONE]') continue;

            // 处理每一行
            if (line.startsWith('data: ')) {
              final jsonData = line.substring(6).trim();
              if (jsonData == '[DONE]') continue;

              try {
                final Map<String, dynamic> data = json.decode(jsonData);
                final String? content =
                    data['choices']?[0]?['delta']?['content'];
                if (content != null && content.isNotEmpty) {
                  // 直接发送增量内容，不累积
                  streamController.add(content);
                }
              } catch (e) {
                print('解析流式响应失败: $e，原始数据: $jsonData');
              }
            }
          }
        },
        onDone: () {
          // 流结束时关闭控制器
          streamController.close();
        },
        onError: (error) {
          print('流处理错误: $error');
          streamController.addError(error);
          streamController.close();
        },
      );

      return streamController.stream;
    } catch (e) {
      print('流式请求失败，尝试回退到非流式请求: $e');

      // 判断是否是流式请求不支持的错误
      // 不同API可能有不同的错误格式，这里尝试捕获常见的错误模式
      bool isStreamingNotSupported = false;

      if (e is DioException) {
        // 检查错误响应中是否包含特定错误信息
        final response = e.response;
        if (response != null) {
          final errorData = response.data;
          if (errorData is Map<String, dynamic>) {
            // 检查常见的错误消息模式
            final errorMessage = errorData['error']?['message'] ?? '';
            isStreamingNotSupported = errorMessage.contains('streaming') ||
                errorMessage.contains('stream') ||
                errorMessage.toLowerCase().contains('not supported');
          } else if (errorData is String) {
            isStreamingNotSupported = errorData.contains('streaming') ||
                errorData.contains('stream') ||
                errorData.toLowerCase().contains('not supported');
          }
        }

        // 检查状态码，某些API可能返回特定状态码表示不支持流式
        isStreamingNotSupported = isStreamingNotSupported ||
            e.response?.statusCode == 400 ||
            e.response?.statusCode == 501;
      }

      // 如果是流式不支持或其他错误，回退到非流式请求
      try {
        // 移除stream参数
        requestBody.remove('stream');

        // 发送非流式请求
        final response = await dio.post(
          baseUrl,
          data: requestBody,
        );

        // 从非流式响应中提取内容
        final content =
            response.data['choices'][0]['message']['content'] as String;

        // 返回单一事件的流
        return Stream.value(content);
      } catch (fallbackError) {
        print('非流式请求失败: $fallbackError');
        // 如果非流式请求也失败，返回错误流
        return Stream.error('请求失败: $fallbackError');
      }
    }
  }
}
