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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TextField(
        autofocus: true,
        focusNode: _focusNode,
        controller: widget.messageController,
        maxLines: null,
        onChanged: (value) => setState(() {}),
        onSubmitted: (value) => widget.onSendMessage(),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () => widget.onSendMessage(),
              icon: Icon(
                Icons.send_rounded,
                color: widget.messageController.text.isEmpty ||
                        widget.isWaitingResponse
                    ? Colors.grey
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            border: OutlineInputBorder(),
            labelText: tr(LocaleKeys.chatPageInputHintText)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildInput();
  }
}
