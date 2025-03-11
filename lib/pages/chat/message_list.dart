import 'package:ai_client/models/chat_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;

  const MessageList({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  /// 构建消息项
  Widget _buildMessageItem(BuildContext context, ChatMessage message) {
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
          data:
              '${message.content}\n\n${DateFormat('yyyy-MM-dd HH:mm:ss').format(message.createdTime)}',
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) =>
          _buildMessageItem(context, messages[index]),
    );
  }
}
