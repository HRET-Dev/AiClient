import 'package:ai_client/common/utils/message_markdown.dart';
import 'package:ai_client/models/chat_message.dart';
import 'package:ai_client/pages/chat/chat_provider.dart';
import 'package:ai_client/pages/chat/message_action_buttons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;
  // 聊天提供者
  final ChatProvider chatProvider;

  const MessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.chatProvider,
  });

  /// 根据模型名称获取对应的图标
  Widget _getModelIcon(BuildContext context, String modelName) {
    // 使用主题颜色
    final Color iconColor = Theme.of(context).colorScheme.onPrimary;

    // 默认图标
    Widget defaultIcon = const Icon(
      Icons.smart_toy_outlined,
      color: Colors.white,
      size: 16,
    );

    // 转换为小写进行模糊匹配
    String lowerModelName = modelName.toLowerCase();

    // 模糊匹配不同的模型
    if (lowerModelName.contains('gpt') ||
        RegExp(r'^o\d+').hasMatch(lowerModelName)) {
      // 所有GPT模型统一使用OpenAI图标
      return SvgPicture.asset(
        'assets/assistant/openai.svg',
        width: 16,
        height: 16,
        // 使用主题颜色
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        // SVG加载失败时显示默认图标
        placeholderBuilder: (BuildContext context) => defaultIcon,
      );
    } else if (lowerModelName.contains('claude')) {
      return SvgPicture.asset(
        'assets/assistant/claude.svg',
        width: 16,
        height: 16,
        // 使用主题颜色
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        // SVG加载失败时显示默认图标
        placeholderBuilder: (BuildContext context) => defaultIcon,
      );
    } else if (lowerModelName.contains('gemini')) {
      return SvgPicture.asset(
        'assets/assistant/gemini.svg',
        width: 16,
        height: 16,
        // 使用主题颜色
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        // SVG加载失败时显示默认图标
        placeholderBuilder: (BuildContext context) => defaultIcon,
      );
    } else if (lowerModelName.contains('llama')) {
      return SvgPicture.asset(
        'assets/assistant/ollama.svg',
        width: 16,
        height: 16,
        // 使用主题颜色
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        // SVG加载失败时显示默认图标
        placeholderBuilder: (BuildContext context) => defaultIcon,
      );
    } else if (lowerModelName.contains('deepseek')) {
      return SvgPicture.asset(
        'assets/assistant/deepseek.svg',
        width: 16,
        height: 16,
        // 使用主题颜色
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        // SVG加载失败时显示默认图标
        placeholderBuilder: (BuildContext context) => defaultIcon,
      );
    } else if (lowerModelName.contains('grok')) {
      return SvgPicture.asset(
        'assets/assistant/grok.svg',
        width: 16,
        height: 16,
        // 使用主题颜色
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        // SVG加载失败时显示默认图标
        placeholderBuilder: (BuildContext context) => defaultIcon,
      );
    } else if (lowerModelName.contains('qwen')) {
      return SvgPicture.asset(
        'assets/assistant/qwen.svg',
        width: 16,
        height: 16,
        // 使用主题颜色
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        // SVG加载失败时显示默认图标
        placeholderBuilder: (BuildContext context) => defaultIcon,
      );
    } else {
      return defaultIcon;
    }
  }

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

    // 使用主题颜色
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    /// 时间格式化器
    final dateFormat = DateFormat('HH:mm:ss');

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
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.primary, width: 1),
            ),
            child: Icon(
              Icons.person,
              color: colorScheme.onPrimaryContainer,
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
                // 时间
                Text(
                  dateFormat.format(message.createTime),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),

                // 消息内容
                // MarkdownBody(
                //   data: message.content,
                //   styleSheet: MarkdownStyleSheet(
                //     p: TextStyle(fontSize: 15, height: 1.4),
                //     strong: const TextStyle(fontWeight: FontWeight.bold),
                //     em: const TextStyle(fontStyle: FontStyle.italic),
                //     code: TextStyle(fontFamily: 'monospace'),
                //   ),
                //   selectable: true,
                // ),

                // markdown渲染消息内容
                MessageMarkdown(content: message.content),

                // 消息操作按钮
                MessageActionButtons(
                  messageRole: message.role,
                  onDelete: () {
                    // 处理删除消息的逻辑
                    chatProvider.deleteMessage(message.id);
                  },
                  onRegenerate: () {
                    // 处理重新生成消息的逻辑
                    chatProvider.regenerateMessage(message.id);
                  },
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

    // 使用主题颜色
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // 根据模型名称获取对应的图标
    Widget modelIcon = _getModelIcon(context, message.model.toString());

    /// 时间格式化器
    final dateFormat = DateFormat('HH:mm:ss');

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
              // 使用主题的主要颜色
              color: colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.primary, width: 1),
            ),
            padding: const EdgeInsets.all(3),
            child: modelIcon,
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
                // 时间
                Text(
                  dateFormat.format(message.createTime),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),

                // 消息内容
                // MarkdownBody(
                //   data: message.content,
                //   styleSheet: MarkdownStyleSheet(
                //     p: TextStyle(fontSize: 15, height: 1.4),
                //     strong: const TextStyle(fontWeight: FontWeight.bold),
                //     em: const TextStyle(fontStyle: FontStyle.italic),
                //     code: TextStyle(fontFamily: 'monospace'),
                //     blockquote: TextStyle(
                //         color: Colors.grey.shade700,
                //         fontStyle: FontStyle.italic),
                //     blockquoteDecoration: BoxDecoration(
                //       color: Colors.grey.shade100,
                //       borderRadius: BorderRadius.circular(2),
                //       border: Border(
                //           left: BorderSide(
                //               color: Colors.grey.shade300, width: 4)),
                //     ),
                //   ),
                //   selectable: true,
                // ),

                // markdown渲染消息内容
                MessageMarkdown(content: message.content),

                // 消息操作按钮
                MessageActionButtons(
                  messageRole: message.role,
                  onDelete: () {
                    // 处理删除消息的逻辑
                    chatProvider.deleteMessage(message.id);
                  },
                  onRegenerate: () {
                    // 处理重新生成消息的逻辑
                    chatProvider.regenerateMessage(message.id);
                  },
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
