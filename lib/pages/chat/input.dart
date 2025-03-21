import 'package:ai_client/common/theme/app_theme.dart';
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 输入框
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxHeight: 120), // 限制最大高度
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  hintText: tr(LocaleKeys.chatPageInputHintText),
                  hintStyle:
                      TextStyle(fontSize: 15, color: Colors.grey.shade500),
                ),
              ),
            ),
          ),
          // 发送按钮
          Container(
            margin: EdgeInsets.only(left: 12, bottom: 4),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: widget.messageController.text.isEmpty ||
                      widget.isWaitingResponse
                  ? Colors.grey.shade400
                  : AppTheme.getAppColor(context),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
                color: Colors.white,
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
