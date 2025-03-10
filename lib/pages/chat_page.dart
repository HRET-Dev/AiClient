import 'package:ai_client/common/utils/chat_http.dart';
import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/models/chat_messages.dart';
import 'package:ai_client/repositories/ai_api__repository.dart';
import 'package:ai_client/services/ai_api_service.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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

  /// 构建输入区域
  Widget _buildInputArea() {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: tr(LocaleKeys.chatPageInputHintText),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onChanged: (text) {
                  setState(() {});
                },
                onSubmitted: (_) => _inputConfirm(),
                textInputAction: TextInputAction.send,
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: _messageController.text.isEmpty
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
              ),
              onPressed: _inputConfirm,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建消息项
  Widget _buildMessageItem(ChatMessage message) {
    return Container(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser
              ? TDTheme.of(context).brandColor6.withOpacity(0.2)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: MarkdownBody(
          data: '${message.content}\n\n${DateFormat('yyyy-MM-dd HH:mm:ss').format(message
          .createdTime)}',
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(fontSize: 16, color: Colors.black),
            strong: TextStyle(fontWeight: FontWeight.bold),
            em: TextStyle(fontStyle: FontStyle.italic),
            code: TextStyle(
                backgroundColor: Colors.grey[300], fontFamily: 'monospace'),
          ),
          selectable: true,
        ),
      ),
    );
  }

  /// 输入框
  Future<void> _inputConfirm() async {
    // 判断输入框是否为空 或者 正在等待回复
    if (_isWaitingResponse || _messageController.text.isEmpty) return;

    // 判断是否有可用 API 配置信息
    if (_apiConfig.isEmpty) {
      TDToast.showText('无可用 API 配置信息', context: context);
      return;
    }

    // 当前没有 API 配置信息时，默认使用第一条
    _currentApi ??= _apiConfig[0];

    // 存储一个新的消息列表 防止历史消息被覆盖
    List<ChatMessage> newMessages = List.from(_messages);

    final userMessage = _messageController.text;
    setState(() {
      _messages.add(ChatMessage(content: userMessage, isUser: true, createdTime: DateTime.now()));
      _messageController.clear();
      _isWaitingResponse = true; // 设置等待状态
    });
    // 滚动到最底部
    _scrollToBottom();

    // 默认加载中
    final aiMessage =
        ChatMessage(content: tr(LocaleKeys.chatPageThinking), isUser: false, createdTime: DateTime.now());
    setState(() {
      _messages.add(aiMessage);
    });

    try {
      final responseStream = await _chatHttp.sendStreamChatRequest(
        api: _currentApi!,
        message: userMessage,
        historys: newMessages
      );

      // 用于累积AI回复的内容
      String accumulatedContent = "";

      // 处理流
      responseStream.listen(
        (content) {
          // 累积内容
          accumulatedContent += content;
          
          // 更新消息内容
          setState(() {
            aiMessage.content = accumulatedContent;
          });
          // 滚动到最底部
          _scrollToBottom();
        },
        onDone: () {
          // 流结束时的处理
          setState(() {
            _isWaitingResponse = false; // 清除等待状态
          });
          // 滚动到最底部
          _scrollToBottom();
        },
        onError: (error) {
          // 错误处理
          setState(() {
            aiMessage.content = "发生错误: $error";
            _isWaitingResponse = false; // 清除等待状态
          });
          // 滚动到最底部
          _scrollToBottom();
        }
      );
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
          _messages[loadingIndex] =
              ChatMessage(content: errorMessage, isUser: false, createdTime: DateTime.now());
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
            Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) =>
                      _buildMessageItem(_messages[index])),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }
}
