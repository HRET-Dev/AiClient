import 'package:ai_client/common/utils/db/ai_api_repository.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/models/ai_api.dart';
import 'package:ai_client/services/chat/chat_http.dart';
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
  final ChatHttp _chatHttp = ChatHttp(Dio());
  // 用于查询存储在本地的 API 配置信息
  final AIApiRepository _apiRepository = AIApiRepository();
  // 加载到的 API 配置
  AIApi? _apiConfig;

  @override
  void initState() {
    super.initState();
    _loadApiConfig();
  }

  // 从 SQLite 数据库中加载 API 配置信息，优先取第一条记录
  Future<void> _loadApiConfig() async {
    final apis = await _apiRepository.getAllAIApis();
    if (apis.isNotEmpty) {
      setState(() {
        _apiConfig = apis.first;
      });
    } else {
      // 若数据库中没有配置，也可以考虑使用默认配置或提示用户配置相关信息
      TDToast.showText('未找到 API 配置信息', context: context);
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
        child: Text(message.content),
      ),
    );
  }

  Future<void> _inputConfirm() async {
    if (_messageController.text.isEmpty) return;

    final userMessage = _messageController.text;
    setState(() {
      _messages.add(ChatMessage(content: userMessage, isUser: true));
      _messageController.clear();
    });
    _scrollToBottom();

    if (_apiConfig == null) {
      TDToast.showText('无可用 API 配置信息', context: context);
      return;
    }

    try {
      final response = await _chatHttp.sendChatRequest(
        api: _apiConfig!,
        message: userMessage,
      );
      // 根据实际返回数据解析 AI 回复内容
      final aiReply =
          response.data['choices']?[0]['message']['content'] ?? '无回复';
      setState(() {
        _messages.add(ChatMessage(content: aiReply, isUser: false));
      });
    } catch (e) {
      TDToast.showText('请求出错: $e', context: context);
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
