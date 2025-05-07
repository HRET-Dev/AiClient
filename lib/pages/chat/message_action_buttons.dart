import 'package:ai_client/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ai_client/generated/locale_keys.dart';

/// 消息操作按钮组件
/// 用于在消息内容下方显示操作按钮
class MessageActionButtons extends StatelessWidget {
  /// 消息类型 MessageRole
  final MessageRole messageRole;

  /// 删除消息回调函数
  final VoidCallback onDelete;

  /// 重新回答回调函数
  final VoidCallback onRegenerate;

  /// 按钮大小
  final double iconSize;

  /// 按钮间距
  final double spacing;

  /// 构造函数
  const MessageActionButtons({
    super.key,
    required this.messageRole,
    required this.onDelete,
    required this.onRegenerate,
    this.iconSize = 20.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    // 获取主题
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 删除按钮
          _buildActionButton(
            context: context,
            icon: Icons.delete_sweep,
            tooltip: LocaleKeys.delete.tr(),
            onPressed: onDelete,
            color: theme.colorScheme.error,
          ),
          SizedBox(width: spacing),
          if (messageRole != MessageRole.user)
            // 重新回答按钮
            _buildActionButton(
              context: context,
              icon: Icons.refresh,
              tooltip: '重新回答',
              onPressed: onRegenerate,
              color: theme.colorScheme.primary,
            ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withAlpha(1),
              width: 1.0,
            ),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: color,
          ),
        ),
      ),
    );
  }
}
