import 'dart:async';
import 'package:ai_client/generated/default_api_configs.dart';
import 'package:ai_client/models/ai_api.dart';
import 'package:ai_client/models/chat_message.dart';
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

  // 用于取消请求的CancelToken
  CancelToken? _cancelToken;

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
    required AiApi api,
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
          'role': history.role.name,
          'content': history.content,
        };
        // 将角色和内容添加到请求体的 messages 列表中
        messages.add(roleContent);
      }
    }

    // 设置新消息
    messages.add({'role': MessageRole.user.name, 'content': message});

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
  /// [useStream]：是否使用流式请求，默认为 true
  Future<dynamic> sendChatRequestAuto({
    required AiApi api,
    required String model,
    required String message,
    List<ChatMessage>? historys,
    bool useStream = true,
  }) async {
    // 根据 useStream 参数决定使用哪种请求方式
    if (useStream) {
      return sendStreamChatRequest(
        api: api,
        model: model,
        message: message,
        historys: historys,
      );
    } else {
      return sendChatRequest(
        api: api,
        model: model,
        message: message,
        historys: historys,
      );
    }
  }

  Future<Stream<String>> sendStreamChatRequest({
    required AiApi api,
    required String model,
    required String message,
    List<ChatMessage>? historys,
    CancelToken? cancelToken,
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
          'role': history.role,
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
      // 创建或使用传入的CancelToken
      _cancelToken = cancelToken ?? CancelToken();

      // 尝试发送流式请求
      final response = await dio.post(
        baseUrl,
        data: requestBody,
        cancelToken: _cancelToken,
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
      print('流式请求失败: $e');

      return Stream.error('请求失败: $e');
    }
  }

  /// 取消当前的流式请求
  void cancelCurrentRequest() {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel('用户取消请求');
    }
  }

  /// 检查当前是否有正在进行的请求
  bool get hasActiveRequest =>
      _cancelToken != null && !_cancelToken!.isCancelled;
}
