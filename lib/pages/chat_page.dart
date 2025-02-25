import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 聊天
class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  // 文本输入框内容
  TextEditingController _messageController = TextEditingController(); // 非空初始化
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// 文本消息框
  Widget _buildInputArea() {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 8, // 键盘高度 + 安全间距
      ),
      child: TDInput(
        controller: _messageController,
        width: MediaQuery.of(context).size.width - 20,
        backgroundColor: Colors.white,
        hintText: tr('chat_page.input_hintText'),
        rightBtn: _messageController.text.isEmpty
            ? Icon(
                TDIcons.arrow_up_circle_filled,
                color: TDTheme.of(context).grayColor5,
              )
            : Icon(
                TDIcons.arrow_up_circle_filled,
                color: TDTheme.of(context).brandColor6,
              ),
        onBtnTap: () {
          _inputConfirm();
        },
        onEditingComplete: () {
          _inputConfirm();
        },
        onChanged: (text) {
          setState(() {});
        },
        needClear: false,
      ),
    );
  }

  /// 文本消息框确认事件方法
  void _inputConfirm() {
    // 判断是否输入了值
    if (_messageController.text.isEmpty) {
      // 空值不做任何操作
      return;
    }

    TDToast.showText('发送消息：${_messageController.text}', context: context);
    // 清除输入值
    _messageController.clear();
    // 刷新输入框状态
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 确保键盘弹出时布局调整
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  Text("聊天内容..."),
                ],
              ),
            ),
            // 底部文本消息框
            _buildInputArea(),
          ],
        ),
      ),
    );
  }
}
