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
  final ChatHttp _chatHttp = ChatHttp(Dio());

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

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 60,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  /// 构建输入区域
  Widget _buildInputArea() {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
      ),
      child: TDInput(
        controller: _messageController,
        width: MediaQuery.of(context).size.width - 20,
        backgroundColor: Colors.white,
        hintText: tr(LocaleKeys.chatPageInputHintText),
        rightBtn: _messageController.text.isEmpty
            ? Icon(
                TDIcons.arrow_up_circle_filled,
                color: TDTheme.of(context).grayColor5,
              )
            : Icon(
                TDIcons.arrow_up_circle_filled,
                color: TDTheme.of(context).brandColor6,
              ),
        onBtnTap: _inputConfirm,
        onEditingComplete: _inputConfirm,
        onChanged: (text) {
          setState(() {});
        },
        needClear: false,
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
    _scrollToBottom();

    // 添加一个临时的"加载中"消息
    final loadingMessage =
        ChatMessage(content: tr(LocaleKeys.chatPageThinking), isUser: false, createdTime: DateTime.now());
    setState(() {
      _messages.add(loadingMessage);
    });
    _scrollToBottom();

    try {
      final response = await _chatHttp.sendChatRequest(
        api: _currentApi!,
        message: userMessage,
        historys: newMessages
      );
      // 根据实际返回数据解析 AI 回复内容
      final aiReply =
          response.data['choices']?[0]['message']['content'] ?? '无回复';
      setState(() {
        // 找到加载消息的索引并替换它
        final loadingIndex = _messages.indexOf(loadingMessage);
        if (loadingIndex != -1) {
          _messages[loadingIndex] =
              ChatMessage(content: aiReply, isUser: false, createdTime: DateTime.now());
        }
        _isWaitingResponse = false; // 清除等待状态
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
        final loadingIndex = _messages.indexOf(loadingMessage);
        if (loadingIndex != -1) {
          _messages[loadingIndex] =
              ChatMessage(content: errorMessage, isUser: false, createdTime: DateTime.now());
        }
        _isWaitingResponse = false; // 清除等待状态
      });
    }
    _scrollToBottom();
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
