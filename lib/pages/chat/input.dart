import 'package:ai_client/generated/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController messageController;
  final bool isWaitingResponse;
  final Function() onSendMessage;

  const InputWidget({
    super.key,
    required this.messageController,
    required this.isWaitingResponse,
    required this.onSendMessage,
  });

  @override
  State<StatefulWidget> createState() => InputState();
}

class InputState extends State<InputWidget> {
  /// 输入框焦点
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // 释放焦点
    _focusNode.dispose();
    super.dispose();
  }

  /// 构建输入框
  Widget _buildInput() {
    // 获取主题信息
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 输入框
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: theme.focusColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                autofocus: true,
                focusNode: _focusNode,
                controller: widget.messageController,
                maxLines: null,
                minLines: 1,
                onChanged: (value) => setState(() {}),
                onSubmitted: (value) => widget.onSendMessage(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.hoverColor,
                  hintText: tr(LocaleKeys.chatPageInputHintText),
                ),
              ),
            ),
          ),
          // 发送按钮
          Container(
            margin: EdgeInsets.only(left: 6, bottom: 4),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.messageController.text.isEmpty ||
                      widget.isWaitingResponse
                  ? theme.disabledColor
                  : theme.buttonTheme.colorScheme?.onPrimaryFixedVariant,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: widget.messageController.text.isEmpty ||
                      widget.isWaitingResponse
                  ? null
                  : () => widget.onSendMessage(),
              icon: Icon(
                Icons.send_rounded,
                size: 20,
                color: theme.colorScheme.onPrimary,
              ),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildInput();
  }
}
