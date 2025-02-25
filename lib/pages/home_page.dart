import 'package:ai_client/pages/chat_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 正确初始化控制器
  }

  @override
  void dispose() {
    _tabController.dispose(); // 需要释放资源
    super.dispose();
  }

  Widget _buildItemWithIcon() {
    final tabs = [
      TDTab(
        text: tr('Chat'),
        icon: Icon(
          TDIcons.chat_bubble_1,
          size: 18,
        ),
      ),
      TDTab(
        text: tr('History'),
        icon: Icon(
          TDIcons.chat_bubble_history,
          size: 18,
        ),
      ),
      TDTab(
        text: tr('Settings'),
        icon: const Icon(
          TDIcons.setting,
          size: 18,
        ),
      ),
    ];

    return TDTabBar(
      tabs: tabs,
      controller: _tabController, // 使用成员变量控制器
      backgroundColor: Colors.white,
      showIndicator: true,
    );
  }

  // 为导航栏添加底部安全距离
  Widget _buildBottomBarWithSafeArea() {
    return SafeArea(
      top: false, // 不需要顶部安全区域
      minimum: const EdgeInsets.only(bottom: 4), // 最小保持4dp的间距
      child: _buildItemWithIcon(),
    );
  }

  /// 切换语言
  void _changeLocale() async {
    // 获取当前语言在支持的语言列表中的索引
    final currentIndex = context.supportedLocales.indexOf(context.locale);

    // 计算下一个语言的索引，使用取模运算确保循环切换
    final nextIndex = (currentIndex + 1) % context.supportedLocales.length;

    // 切换到下一个语言
    await context.setLocale(context.supportedLocales[nextIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatPage(), // 聊天
          Container(), // 历史
          Container(), // 设置
        ],
      ),
      bottomNavigationBar: _buildBottomBarWithSafeArea(),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeLocale,
        tooltip: '切换语言',
        child: Icon(TDIcons.earth),
      ),
    );
  }
}
