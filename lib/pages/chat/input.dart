import 'package:ai_client/generated/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController messageController;
  final bool isWaitingResponse;
  final Function() onSendMessage;
  final VoidCallback? onStopGeneration;

  const InputWidget({
    super.key,
    required this.messageController,
    required this.isWaitingResponse,
    required this.onSendMessage,
    this.onStopGeneration,
  });

  @override
  State<StatefulWidget> createState() => InputState();
}

class InputState extends State<InputWidget> {
  /// 构建输入框
  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 输入框
          Expanded(
            child: ShadInput(
              controller: widget.messageController,
              placeholder: Text(tr(LocaleKeys.chatPageInputHintText)),
              maxLines: null,
              minLines: 1,
              onChanged: (value) => setState(() {}),
              onSubmitted: (value) => widget.onSendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          // 发送/停止按钮
          ShadButton(
            onPressed: widget.isWaitingResponse
                ? () => widget.onStopGeneration?.call() // 等待回复时点击停止
                : widget.messageController.text.isEmpty
                    ? null
                    : () => widget.onSendMessage(), // 正常发送
            leading: Icon(
              widget.isWaitingResponse
                  ? Icons.stop_rounded // 等待回复时显示停止图标
                  : Icons.send_rounded, // 正常时显示发送图标
              size: 16,
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
