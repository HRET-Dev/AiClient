import 'package:ai_client/common/utils/chat_http.dart';
import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/models/chat_messages.dart';
import 'package:ai_client/pages/chat/input.dart';
import 'package:ai_client/pages/chat/message_list.dart';
import 'package:ai_client/repositories/ai_api_repository.dart';
import 'package:ai_client/services/ai_api_service.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 聊天页面，同时集成了 HTTP 请求和 SQLite 加载 API 配置信息
class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  List<ChatMessage> _messages = [];
  TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // 使用 ChatHttp 调用 OpenAI 接口
  final ChatHttp _chatHttp = ChatHttp();

  /// AiApi 服务类
  final AiApiService _aiApiService =
      AiApiService(AiApiRepository(AppDatabase()));

  // 加载到的 API 配置列表
  late List<AiApiData> _apiConfig;

  // 当前正在使用的 API 配置
  AiApiData? _currentApi;

  // 当前模型列表
  List<String> _models = [];

  // 当前选择的 模型
  String _currentModel = "";

  // 是否正在等待回复
  bool _isWaitingResponse = false;

  @override
  void initState() {
    super.initState();
    _loadApiConfig();
  }

  // 从 SQLite 数据库中加载 API 配置信息，优先取第一条记录
  Future<void> _loadApiConfig() async {
    final apis = await _aiApiService.initDefaultAiApiConfig();
    if (apis.isNotEmpty) {
      setState(() {
        // 设置 API 配置列表
        _apiConfig = apis;
      });
    } else {
      if (mounted) {
        // 若数据库中没有配置，也可以考虑使用默认配置或提示用户配置相关信息
        TDToast.showText('未找到 API 配置信息', context: context);
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// 滚动到最底部
  void _scrollToBottom() {
    // 添加短暂延迟，确保布局已更新
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 发送消息
  Future<void> _sendMessage() async {
    // 判断输入框是否为空 或者 正在等待回复
    if (_isWaitingResponse || _messageController.text.isEmpty) return;

    // 判断是否有可用 API 配置信息
    if (_apiConfig.isEmpty) {
      TDToast.showText('无可用 API 配置信息', context: context);
      return;
    }

    // 当前没有 API 配置信息时，默认使用第一条
    _currentApi ??= _apiConfig[0];

    // 加载模型列表
    _models = _currentApi!.models.split(',');

    // 当前没有模型时，默认使用第一条
    if (_currentModel.isEmpty) {
      _currentModel = _models.isNotEmpty ? _models[0] : "";
    }

    // 存储一个新的消息列表 防止历史消息被覆盖
    List<ChatMessage> newMessages = List.from(_messages);

    final userMessage = _messageController.text;
    setState(() {
      _messages.add(ChatMessage(
          content: userMessage,
          isUser: true,
          modelName: _currentModel,
          createdTime: DateTime.now()));
      _messageController.clear();
      _isWaitingResponse = true; // 设置等待状态
    });
    // 滚动到最底部
    _scrollToBottom();

    // 默认加载中
    final aiMessage = ChatMessage(
        content: tr(LocaleKeys.chatPageThinking),
        isUser: false,
        modelName: _currentModel,
        createdTime: DateTime.now());
    setState(() {
      _messages.add(aiMessage);
    });

    try {
      final responseStream = await _chatHttp.sendStreamChatRequest(
          api: _currentApi!,
          model: _currentModel,
          message: userMessage,
          historys: newMessages);

      // 用于累积AI回复的内容
      String accumulatedContent = "";

      // 处理流
      responseStream.listen((content) {
        // 累积内容
        accumulatedContent += content;

        // 更新消息内容
        setState(() {
          aiMessage.content = accumulatedContent;
        });
        // 滚动到最底部
        _scrollToBottom();
      }, onDone: () {
        // 流结束时的处理
        setState(() {
          _isWaitingResponse = false; // 清除等待状态
        });
        // 滚动到最底部
        _scrollToBottom();
      }, onError: (error) {
        // 错误处理
        setState(() {
          aiMessage.content = "发生错误: $error";
          _isWaitingResponse = false; // 清除等待状态
        });
        // 滚动到最底部
        _scrollToBottom();
      });
    } catch (e) {
      // 控制台打印错误信息
      print('请求出错: $e');
      // 出错时，显示错误信息
      String errorMessage = '请求出错';
      if (e is DioException && e.response != null) {
        errorMessage =
            '请求出错: 状态码 ${e.response!.statusCode} - ${e.response!.data}';
      } else {
        errorMessage = '请求出错: $e';
      }
      setState(() {
        // 找到加载消息的索引并替换它
        final loadingIndex = _messages.indexOf(aiMessage);
        if (loadingIndex != -1) {
          _messages[loadingIndex] = ChatMessage(
              content: errorMessage,
              isUser: false,
              modelName: _currentModel,
              createdTime: DateTime.now());
        }
        _isWaitingResponse = false; // 清除等待状态
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部工具栏
            Padding(
              // 增加顶部内边距
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 新对话按钮
                  IconButton(
                    icon: Icon(Icons.new_label_outlined),
                    onPressed: () {
                      setState(() {
                        _messages.clear();
                      });
                    },
                    // 提示
                    tooltip: tr(LocaleKeys.chatPageNewChat),
                  )
                ],
              ),
            ),
            // 消息内容区
            Expanded(
              child: MessageList(
                messages: _messages,
                scrollController: _scrollController,
              ),
            ),
            // 输入框
            InputWidget(
              messageController: _messageController,
              isWaitingResponse: _isWaitingResponse,
              onSendMessage: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
