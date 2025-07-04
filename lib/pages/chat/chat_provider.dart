import 'dart:convert';

import 'package:ai_client/common/utils/chat_http.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/models/ai_api.dart';
import 'package:ai_client/models/chat_message.dart';
import 'package:ai_client/models/chat_session.dart';
import 'package:ai_client/services/ai_api_service.dart';
import 'package:ai_client/services/chat_message_service.dart';
import 'package:ai_client/services/chat_session_service.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider extends ChangeNotifier {
  // 使用 ChatHttp 调用 OpenAI 接口
  final ChatHttp chatHttp = ChatHttp();

  // 用于取消当前请求的CancelToken
  CancelToken? _currentCancelToken;

  /// AiApi 服务类
  late final AiApiService aiApiService;

  /// 聊天会话 服务类
  late final ChatSessionService chatSessionService;

  /// 聊天信息 服务类
  late final ChatMessageService chatMessageService;

  /// SharedPreferences 当前会话ID键名
  final String currentSessionId = "currentSessionId";

  // 构造函数
  ChatProvider() {
    // 初始化 AiApi 服务类
    aiApiService = AiApiService();
    // 初始化聊天会话 服务类
    chatSessionService = ChatSessionService();
    // 初始化聊天信息 服务类
    chatMessageService = ChatMessageService();

    // 初始化 API 配置
    loadApiConfig();

    // 从shared_preferences 加载当前会话ID
    loadChatSessionId();
  }

  /// 从 SQLite 数据库中加载 API 配置信息
  Future<void> loadApiConfig() async {
    final apis = await aiApiService.initDefaultAiApiConfig();
    if (apis.isNotEmpty) {
      apiConfigs = apis;
      notifyListeners();
    }
  }

  /// 从 SharedPreferences 加载当前会话ID
  Future<void> loadChatSessionId() async {
    // 获取SharedPreferences实例
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 从shared_preferences中获取当前会话ID
    int? sessionId = prefs.getInt(currentSessionId);

    // 如果会话ID不为空，则加载对应的聊天记录
    if (sessionId != null) {
      loadChatMessages(sessionId);
    }
  }

  /// 保存当前会话ID
  Future<void> saveChatSessionId(int sessionId) async {
    // 获取SharedPreferences实例
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 保存当前会话ID
    prefs.setInt(currentSessionId, sessionId);
  }

  /// 删除当前会话ID
  Future<void> removeChatSessionId() async {
    // 获取SharedPreferences实例
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 删除当前会话ID
    prefs.remove(currentSessionId);
  }

  // 消息列表
  List<ChatMessage> messages = [];

  // 聊天会话 ID
  int chatSessionId = 0;

  // 聊天会话名称
  String chatSessionName = "新会话";

  // 加载到的 API 配置列表
  late List<AiApi> apiConfigs;

  // 当前正在使用的 API 配置
  AiApi? currentApi;

  // 当前模型列表
  List<String> models = [];

  // 当前选择的 模型
  String currentModel = "";

  // 是否正在等待回复
  bool isWaitingResponse = false;

  // 是否使用流式请求
  bool useStream = false;

  // 输入框控制器
  final TextEditingController inputController = TextEditingController();

  // 滚动控制器
  final ScrollController scrollController = ScrollController();

  /// 根据会话ID 加载对应的聊天记录列表
  Future<void> loadChatMessages(int sessionId,
      {ChatSession? chatSession}) async {
    // 判断是否传递了会话信息
    if (chatSession != null) {
      // 设置聊天会话ID
      sessionId = chatSession.id;
      // 设置聊天会话ID到当前对象
      chatSessionId = sessionId;
      // 设置聊天会话名称
      chatSessionName = chatSession.title;

      // 获取api id
      final apiConfigId = chatSession.apiConfigId;
      // 根据配置id查询对应的api信息
      final apiConfig = apiConfigs.firstWhere((api) => api.id == apiConfigId);
      // 判断是否有API信息
      if (apiConfig.id > 0) {
        currentApi = apiConfig;
        currentModel = chatSession.model.toString();
      }
    } else {
      // 根据会话ID 查询会话信息
      final session = await chatSessionService.getSessionById(sessionId);
      // 判断是否有数据
      if (session != null) {
        // 设置聊天会话ID
        chatSessionId = session.id;
        // 设置聊天会话名称
        chatSessionName = session.title;
        // 获取api id
        final apiConfigId = session.apiConfigId;
        // 根据配置id查询对应的api信息
        final apiConfig = apiConfigs.firstWhere((api) => api.id == apiConfigId);
        // 判断是否有API信息
        if (apiConfig.id > 0) {
          currentApi = apiConfig;
          currentModel = session.model.toString();
        }
      }
    }

    // 根据会话ID 查询会话信息
    final messages = await chatMessageService.getMessagesBySessionId(sessionId);

    // 设置聊天会话ID
    chatSessionId = sessionId;

    // 保存当前会话ID
    saveChatSessionId(chatSessionId);

    // 设置聊天信息
    this.messages = messages;

    // 无论是否有消息，都通知监听器更新UI
    notifyListeners();
  }

  /// 加载指定会话的聊天记录列表
  void loadSession(ChatSession chatSession) {
    // 清空当前会话
    clearChat();

    // 加载历史聊天记录
    loadChatMessages(0, chatSession: chatSession);
  }

  /// 发送消息
  Future<void> sendMessage(String content) async {
    // 判断输入框是否为空 或者 正在等待回复
    if (isWaitingResponse || content.isEmpty) return;

    // 判断是否有可用 API 配置信息
    if (apiConfigs.isEmpty) {
      return;
    }

    // 当前没有 API 配置信息时，默认使用第一条
    currentApi ??= apiConfigs[0];

    // 加载模型列表
    models = currentApi!.models.split(',');

    // 当前没有模型时，默认使用第一条
    if (currentModel.isEmpty) {
      currentModel = models.isNotEmpty ? models[0] : "";
    }

    // 存储一个新的消息列表 防止历史消息被覆盖
    List<ChatMessage> newMessages = List.from(messages);

    final userMessage = content;

    // 添加用户消息
    messages.add(ChatMessage()
      ..sessionId = chatSessionId
      ..content = userMessage
      ..model = currentModel
      ..type = MessageType.system
      ..role = MessageRole.user
      ..createTime = DateTime.now()
      ..status = MessageStatus.sent);
    inputController.clear();
    isWaitingResponse = true; // 设置等待状态

    // 创建新的CancelToken
    _currentCancelToken = CancelToken();
    notifyListeners();

    // 滚动到最底部
    scrollToBottom();

    // 默认加载中
    var aiMessage = ChatMessage()
      ..sessionId = chatSessionId
      ..content = LocaleKeys.chatPageThinking.tr()
      ..model = currentModel
      ..type = MessageType.system
      ..role = MessageRole.assistant
      ..createTime = DateTime.now()
      ..status = MessageStatus.send;
    messages.add(aiMessage);
    notifyListeners();

    // 记录AI消息在消息列表中的索引
    final aiMessageIndex = messages.length - 1;

    try {
      if (useStream) {
        // 流式请求处理
        final responseStream = await chatHttp.sendStreamChatRequest(
            api: currentApi!,
            model: currentModel,
            message: userMessage,
            historys: newMessages,
            cancelToken: _currentCancelToken);

        // 用于累积AI回复的内容
        String accumulatedContent = "";

        // 处理流
        responseStream.listen((content) {
          // 累积内容
          accumulatedContent += content;

          // 更新消息内容
          aiMessage
            ..content = accumulatedContent
            ..status = MessageStatus.sent;

          // 直接使用索引更新messages列表
          if (aiMessageIndex < messages.length) {
            messages[aiMessageIndex] = aiMessage;
          }
          notifyListeners();

          // 滚动到最底部
          scrollToBottom();
        }, onDone: () {
          // 流结束时的处理
          isWaitingResponse = false; // 清除等待状态
          _currentCancelToken = null; // 清除CancelToken
          notifyListeners();

          // 滚动到最底部
          scrollToBottom();

          // 保存聊天记录
          saveChat();
        }, onError: (error) {
          // 封装错误信息
          String errorMessage = '请求出错';

          // 判断错误类型
          if (error is DioException && error.response != null) {
            // 格式化错误信息，使其更易读
            try {
              // 尝试解析JSON格式的错误信息
              var errorData = error.response!.data;
              if (errorData is Map) {
                // 将Map格式的错误信息转换为格式化的JSON字符串
                var prettyError =
                    const JsonEncoder.withIndent('  ').convert(errorData);
                errorMessage =
                    '请求出错: 状态码 ${error.response!.statusCode}\n$prettyError';
              } else {
                errorMessage =
                    '请求出错: 状态码 ${error.response!.statusCode} - ${error.response!.data}';
              }
            } catch (_) {
              // 如果解析失败，使用原始错误信息
              errorMessage =
                  '请求出错: 状态码 ${error.response!.statusCode} - ${error.response!.data}';
            }
          } else {
            errorMessage = '请求出错: $error';
          }

          // 错误的markdown代码块
          String errorMarkdown = '''
            ```error
            $errorMessage
            ```
          ''';

          // 错误处理
          aiMessage
            ..content = errorMarkdown
            ..status = MessageStatus.error;

          // 直接使用索引更新messages列表
          if (aiMessageIndex < messages.length) {
            messages[aiMessageIndex] = aiMessage;
          }

          isWaitingResponse = false; // 清除等待状态
          _currentCancelToken = null; // 清除CancelToken
          notifyListeners();

          // 滚动到最底部
          scrollToBottom();
        });
      } else {
        // 非流式请求处理
        final response = await chatHttp.sendChatRequest(
            api: currentApi!,
            model: currentModel,
            message: userMessage,
            historys: newMessages);

        // 从响应中提取内容
        final content =
            response.data['choices'][0]['message']['content'] as String;

        // 更新消息内容
        aiMessage
          ..content = content
          ..status = MessageStatus.sent;

        // 直接使用索引更新messages列表
        if (aiMessageIndex < messages.length) {
          messages[aiMessageIndex] = aiMessage;
        }

        isWaitingResponse = false; // 清除等待状态
        _currentCancelToken = null; // 清除CancelToken
        notifyListeners();

        // 滚动到最底部
        scrollToBottom();

        // 保存聊天记录
        saveChat();
      }
    } catch (e) {
      // 控制台打印错误信息
      print('请求出错: $e');
      // 出错时，显示错误信息
      String errorMessage = '请求出错';
      // 判断错误类型
      if (e is DioException && e.response != null) {
        // 格式化错误信息，使其更易读
        try {
          // 尝试解析JSON格式的错误信息
          var errorData = e.response!.data;
          if (errorData is Map) {
            // 将Map格式的错误信息转换为格式化的JSON字符串
            var prettyError =
                const JsonEncoder.withIndent('  ').convert(errorData);
            errorMessage = '请求出错: 状态码 ${e.response!.statusCode}\n$prettyError';
          } else {
            errorMessage =
                '请求出错: 状态码 ${e.response!.statusCode} - ${e.response!.data}';
          }
        } catch (_) {
          // 如果解析失败，使用原始错误信息
          errorMessage =
              '请求出错: 状态码 ${e.response!.statusCode} - ${e.response!.data}';
        }
      } else {
        errorMessage = '请求出错: $e';
      }

      // 错误的markdown代码块
      String errorMarkdown = '''
        ```error
        $errorMessage
        ```
      ''';

      // 直接使用之前保存的索引更新消息
      if (aiMessageIndex < messages.length) {
        messages[aiMessageIndex]
          ..sessionId = chatSessionId
          ..content = errorMarkdown
          ..model = currentModel
          ..type = MessageType.system
          ..role = MessageRole.assistant
          ..createTime = DateTime.now()
          ..status = MessageStatus.error;
      }
      isWaitingResponse = false; // 清除等待状态
      _currentCancelToken = null; // 清除CancelToken
      notifyListeners();

      // 保存聊天记录
      saveChat();
    }
  }

  /// 停止当前的AI生成
  void stopGeneration() {
    if (_currentCancelToken != null && !_currentCancelToken!.isCancelled) {
      _currentCancelToken!.cancel('用户停止生成');
      _currentCancelToken = null;
      isWaitingResponse = false;
      notifyListeners();

      // 保存当前的聊天记录
      saveChat();
    }
  }

  /// 保存聊天记录
  Future<void> saveChat() async {
    // 如果没有消息，则不保存
    if (messages.isEmpty) return;

    try {
      // 判断是否是已有会话的聊天记录
      if (chatSessionId != 0) {
        // 更新会话信息
        await chatSessionService.updateSession(chatSessionId,
            apiConfigId: currentApi?.id, model: currentModel);
      } else {
        // 创建会话信息 会话标题取第一条消息的前20个字（如果消息长度不足20个字则取全部）
        final title = messages.isNotEmpty
            ? messages[0].content.toString().length > 20
                ? messages[0].content.toString().substring(0, 20)
                : messages[0].content.toString()
            : "新会话";

        // 保存会话信息并获取会话ID
        int sessionId = await chatSessionService.createSession(title,
            apiConfigId: currentApi!.id, model: currentModel);

        // 更新会话ID
        chatSessionId = sessionId;
        // 更新会话名称
        chatSessionName = title;

        // 保存当前会话ID
        saveChatSessionId(sessionId);
      }

      // 创建聊天信息
      for (int i = 0; i < messages.length; i++) {
        // 获取消息信息
        var message = messages[i];

        // 检查消息是否已经保存过
        if (message.id != 0) continue;

        // 创建文本类型的消息
        int messageId = await chatMessageService.createTextMessage(
            sessionId: chatSessionId,
            content: message.content.toString(),
            apiConfigId: currentApi!.id,
            model: currentModel,
            role: message.role,
            status: message.status);

        // 更新消息的ID
        messages[i].id = messageId;
      }
      notifyListeners();
    } catch (e) {
      print('保存聊天记录失败: $e');
    }
  }

  /// 清除聊天记录
  void clearChat() {
    messages.clear();
    chatSessionId = 0;
    chatSessionName = "新会话";
    currentApi = null;
    currentModel = "";

    // 清除当前会话ID
    removeChatSessionId();
    // 通知监听器更新UI
    notifyListeners();
  }

  /// 滚动到最底部
  void scrollToBottom() {
    // 添加短暂延迟，确保布局已更新
    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 切换流式请求
  void toggleStream() {
    useStream = !useStream;
    notifyListeners();
  }

  /// 切换API配置
  void switchApi(AiApi api) {
    currentApi = api;
    // 更新模型列表
    models = api.models.split(',');
    // 如果当前模型不在新的模型列表中，则选择第一个模型
    if (!models.contains(currentModel) && models.isNotEmpty) {
      currentModel = models[0];
    }
    notifyListeners();
  }

  /// 切换模型
  void switchModel(String model) {
    currentModel = model;
    notifyListeners();
  }

  /// 删除指定消息
  Future<void> deleteMessage(int messageId) async {
    try {
      // 查找消息在列表中的索引
      final index = messages.indexWhere((msg) => msg.id == messageId);
      if (index != -1) {
        // 从数据库中删除消息
        await chatMessageService.deleteMessage(messageId);

        // 从列表中移除消息
        messages.removeAt(index);
        notifyListeners();
      }
    } catch (e) {
      print('删除消息失败: $e');
    }
  }

  /// 重新回答指定消息
  Future<void> regenerateMessage(int messageId) async {
    try {
      // 查找消息在列表中的索引
      final index = messages.indexWhere((msg) => msg.id == messageId);
      if (index != -1 && index > 0) {
        // 获取用户的上一条消息
        final userMessage = messages[index - 1];

        // 删除当前的AI回复
        await chatMessageService.deleteMessage(messageId);
        messages.removeAt(index);

        // 重新生成回答，但不添加新的用户消息
        await regenerateAnswer(userMessage.content.toString());
      }
    } catch (e) {
      print('重新回答消息失败: $e');
    }
  }

  /// 重新生成回答（不添加新的用户消息）
  Future<void> regenerateAnswer(String userMessageContent) async {
    // 判断是否正在等待回复
    if (isWaitingResponse) return;

    // 判断是否有可用 API 配置信息
    if (apiConfigs.isEmpty) {
      return;
    }

    // 当前没有 API 配置信息时，默认使用第一条
    currentApi ??= apiConfigs[0];

    // 加载模型列表
    models = currentApi!.models.split(',');

    // 当前没有模型时，默认使用第一条
    if (currentModel.isEmpty) {
      currentModel = models.isNotEmpty ? models[0] : "";
    }

    // 存储一个新的消息列表 防止历史消息被覆盖
    List<ChatMessage> newMessages = List.from(messages);

    isWaitingResponse = true; // 设置等待状态

    // 创建新的CancelToken
    _currentCancelToken = CancelToken();
    notifyListeners();

    // 滚动到最底部
    scrollToBottom();

    // 默认加载中
    var aiMessage = ChatMessage()
      ..sessionId = chatSessionId
      ..content = LocaleKeys.chatPageThinking.tr()
      ..model = currentModel
      ..type = MessageType.system
      ..role = MessageRole.assistant
      ..createTime = DateTime.now()
      ..status = MessageStatus.send;
    messages.add(aiMessage);
    notifyListeners();

    // 记录AI消息在消息列表中的索引
    final aiMessageIndex = messages.length - 1;

    try {
      if (useStream) {
        // 流式请求处理
        final responseStream = await chatHttp.sendStreamChatRequest(
            api: currentApi!,
            model: currentModel,
            message: userMessageContent,
            historys: newMessages,
            cancelToken: _currentCancelToken);

        // ... 以下代码与sendMessage方法中的流处理部分相同 ...
        // 用于累积AI回复的内容
        String accumulatedContent = "";

        // 处理流
        responseStream.listen((content) {
          // 累积内容
          accumulatedContent += content;

          // 更新消息内容
          aiMessage
            ..content = accumulatedContent
            ..status = MessageStatus.sent;

          // 直接使用索引更新messages列表
          if (aiMessageIndex < messages.length) {
            messages[aiMessageIndex] = aiMessage;
          }
          notifyListeners();

          // 滚动到最底部
          scrollToBottom();
        }, onDone: () {
          // 流结束时的处理
          isWaitingResponse = false; // 清除等待状态
          _currentCancelToken = null; // 清除CancelToken
          notifyListeners();

          // 滚动到最底部
          scrollToBottom();

          // 保存聊天记录
          saveChat();
        }, onError: (error) {
          // ... 错误处理代码与sendMessage方法相同 ...
          // 封装错误信息
          String errorMessage = '请求出错';

          // 判断错误类型
          if (error is DioException && error.response != null) {
            // 格式化错误信息，使其更易读
            try {
              // 尝试解析JSON格式的错误信息
              var errorData = error.response!.data;
              if (errorData is Map) {
                // 将Map格式的错误信息转换为格式化的JSON字符串
                var prettyError =
                    const JsonEncoder.withIndent('  ').convert(errorData);
                errorMessage =
                    '请求出错: 状态码 ${error.response!.statusCode}\n$prettyError';
              } else {
                errorMessage =
                    '请求出错: 状态码 ${error.response!.statusCode} - ${error.response!.data}';
              }
            } catch (_) {
              // 如果解析失败，使用原始错误信息
              errorMessage =
                  '请求出错: 状态码 ${error.response!.statusCode} - ${error.response!.data}';
            }
          } else {
            errorMessage = '请求出错: $error';
          }

          // 错误的markdown代码块
          String errorMarkdown = '''
            ```error
            $errorMessage
            ```
          ''';

          // 错误处理

          aiMessage
            ..content = errorMarkdown
            ..status = MessageStatus.error;

          // 直接使用索引更新messages列表
          if (aiMessageIndex < messages.length) {
            messages[aiMessageIndex] = aiMessage;
          }

          isWaitingResponse = false; // 清除等待状态
          _currentCancelToken = null; // 清除CancelToken
          notifyListeners();

          // 滚动到最底部
          scrollToBottom();
        });
      } else {
        // 非流式请求处理
        final response = await chatHttp.sendChatRequest(
            api: currentApi!,
            model: currentModel,
            message: userMessageContent,
            historys: newMessages);

        // 从响应中提取内容
        final content =
            response.data['choices'][0]['message']['content'] as String;

        // 更新消息内容
        aiMessage
          ..content = content
          ..status = MessageStatus.sent;

        // 直接使用索引更新messages列表
        if (aiMessageIndex < messages.length) {
          messages[aiMessageIndex] = aiMessage;
        }

        isWaitingResponse = false; // 清除等待状态
        notifyListeners();

        // 滚动到最底部
        scrollToBottom();

        // 保存聊天记录
        saveChat();
      }
    } catch (e) {
      // ... 错误处理代码与sendMessage方法相同 ...
      // 控制台打印错误信息
      print('请求出错: $e');
      // 出错时，显示错误信息
      String errorMessage = '请求出错';
      // 判断错误类型
      if (e is DioException && e.response != null) {
        // 格式化错误信息，使其更易读
        try {
          // 尝试解析JSON格式的错误信息
          var errorData = e.response!.data;
          if (errorData is Map) {
            // 将Map格式的错误信息转换为格式化的JSON字符串
            var prettyError =
                const JsonEncoder.withIndent('  ').convert(errorData);
            errorMessage = '请求出错: 状态码 ${e.response!.statusCode}\n$prettyError';
          } else {
            errorMessage =
                '请求出错: 状态码 ${e.response!.statusCode} - ${e.response!.data}';
          }
        } catch (_) {
          // 如果解析失败，使用原始错误信息
          errorMessage =
              '请求出错: 状态码 ${e.response!.statusCode} - ${e.response!.data}';
        }
      } else {
        errorMessage = '请求出错: $e';
      }

      // 错误的markdown代码块
      String errorMarkdown = '''
        ```error
        $errorMessage
        ```
      ''';

      // 直接使用之前保存的索引更新消息
      if (aiMessageIndex < messages.length) {
        messages[aiMessageIndex]
          ..sessionId = chatSessionId
          ..content = errorMarkdown
          ..model = currentModel
          ..type = MessageType.system
          ..role = MessageRole.assistant
          ..createTime = DateTime.now()
          ..status = MessageStatus.error;
      }
      isWaitingResponse = false; // 清除等待状态
      _currentCancelToken = null; // 清除CancelTokens
      notifyListeners();

      // 保存聊天记录
      saveChat();
    }
  }

  @override
  void dispose() {
    inputController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
