import 'package:ai_client/models/chat_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: message.isUser
          ? _buildUserMessage(context, message)
          : _buildAssistantMessage(context, message),
    );
  }

  /// 构建用户消息
  Widget _buildUserMessage(BuildContext context, ChatMessage message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 消息内容区域
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 用户名称和时间
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "User",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _formatTime(message.createdTime),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // 消息内容
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryFixed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: MarkdownBody(
                  data: message.content,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16, color: Colors.black),
                    strong: const TextStyle(fontWeight: FontWeight.bold),
                    em: const TextStyle(fontStyle: FontStyle.italic),
                    code: TextStyle(
                        backgroundColor: Colors.grey[300],
                        fontFamily: 'monospace'),
                  ),
                  selectable: true,
                ),
              ),
            ],
          ),
        ),
        // 用户头像
        Container(
          margin: const EdgeInsets.only(left: 8, top: 4),
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Colors.deepPurpleAccent,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  /// 构建助手消息
  Widget _buildAssistantMessage(BuildContext context, ChatMessage message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI图标
        Container(
          margin: const EdgeInsets.only(right: 8, top: 4),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.smart_toy_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        // 消息内容区域
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 模型名称和时间
              Column(
                children: [
                  Text(
                    message.modelName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    _formatTime(message.createdTime),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // 消息内容
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: MarkdownBody(
                  data: message.content,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 16, color: Colors.black),
                    strong: const TextStyle(fontWeight: FontWeight.bold),
                    em: const TextStyle(fontStyle: FontStyle.italic),
                    code: TextStyle(
                        backgroundColor: Colors.grey[300],
                        fontFamily: 'monospace'),
                  ),
                  selectable: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 格式化时间  HH:mm:ss
  String _formatTime(DateTime? timestamp) {
    if (timestamp == null) return "";

    // 格式化时间
    return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}";
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
