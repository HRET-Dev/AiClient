import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/models/chat_message.dart';
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
    // 获取屏幕宽度，用于判断是否为桌面端
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 600;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8),
      // 限制消息最大宽度
      constraints:
          BoxConstraints(maxWidth: isDesktop ? 800 : screenWidth * 0.9),
      // 消息间距
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: message.role == MessageRole.user
          ? _buildUserMessage(context, message)
          : _buildAssistantMessage(context, message),
    );
  }

  /// 构建用户消息
  Widget _buildUserMessage(BuildContext context, ChatMessage message) {
    // 获取屏幕宽度
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 600;

    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(vertical: 12, horizontal: isDesktop ? 24 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户头像
          Container(
            margin: const EdgeInsets.only(right: 12, top: 4),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 16,
            ),
          ),
          // 消息内容区域
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户名称
                Text(
                  "User",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                // 消息内容
                MarkdownBody(
                  data: message.content,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(fontSize: 15, height: 1.4),
                    strong: const TextStyle(fontWeight: FontWeight.bold),
                    em: const TextStyle(fontStyle: FontStyle.italic),
                    code: TextStyle(fontFamily: 'monospace'),
                  ),
                  selectable: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建助手消息
  Widget _buildAssistantMessage(BuildContext context, ChatMessage message) {
    // 获取屏幕宽度
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 600;

    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(vertical: 12, horizontal: isDesktop ? 24 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI图标
          Container(
            margin: const EdgeInsets.only(right: 12, top: 4),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 16,
            ),
          ),
          // 消息内容区域
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 模型名称
                Text(
                  message.model.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                // 消息内容
                MarkdownBody(
                  data: message.content,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(fontSize: 15, height: 1.4),
                    strong: const TextStyle(fontWeight: FontWeight.bold),
                    em: const TextStyle(fontStyle: FontStyle.italic),
                    code: TextStyle(fontFamily: 'monospace'),
                    blockquote: TextStyle(
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic),
                    blockquoteDecoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(2),
                      border: Border(
                          left: BorderSide(
                              color: Colors.grey.shade300, width: 4)),
                    ),
                  ),
                  selectable: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度，用于判断是否为桌面端
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 600;

    return Center(
      child: Container(
        // 桌面端时限制内容区域最大宽度，并居中显示
        constraints: isDesktop ? BoxConstraints(maxWidth: 900) : null,
        width: isDesktop ? 900 : double.infinity,
        child: ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.zero,
          itemCount: messages.length,
          // 使用分隔线分隔不同的消息
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) =>
              _buildMessageItem(context, messages[index]),
        ),
      ),
    );
  }
}
