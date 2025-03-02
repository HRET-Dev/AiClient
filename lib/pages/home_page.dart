import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/pages/chat_page.dart';
import 'package:ai_client/pages/settings/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
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
        text: tr(LocaleKeys.chat),
        icon: Icon(
          TDIcons.chat_bubble_1,
          size: 18,
        ),
      ),
      TDTab(
        text: tr(LocaleKeys.history),
        icon: Icon(
          TDIcons.chat_bubble_history,
          size: 18,
        ),
      ),
      TDTab(
        text: tr(LocaleKeys.settings),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.only(top: 4), // 最小保持4dp的间距
        child: TabBarView(
          controller: _tabController,
          children: [
            ChatPage(), // 聊天
            Center(
              child: TDEmpty(
                type: TDEmptyType.plain,
                emptyText: tr(LocaleKeys.thisFeatureIsUnderDevelopment),
              ),
            ), // 历史
            SettingsPage(), // 设置
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBarWithSafeArea(),
    );
  }
}
