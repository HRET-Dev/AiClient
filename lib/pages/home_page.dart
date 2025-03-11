import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/pages/chat/chat_page.dart';
import 'package:ai_client/pages/settings/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  /// 导航栏当前选中项
  int selectedIndex = 0;

  /// 导航栏标签显示状态
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  /// 移动端底部导航栏 NavigationBar
  Widget _mobileBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.chat_bubble_outline,
            size: 18,
          ),
          label: tr(LocaleKeys.chat),
        ),
        NavigationDestination(
          icon: Icon(
            Icons.history,
            size: 20,
          ),
          label: tr(LocaleKeys.history),
        ),
        NavigationDestination(
          icon: Icon(
            Icons.settings,
            size: 20,
          ),
          label: tr(LocaleKeys.settings),
        ),
      ],
    );
  }

  /// 桌面端侧边导航栏 NavigationRail
  Widget _desktopNavigationRail() {
    return Column(
      children: [
        Expanded(
          child: NavigationRail(
            selectedIndex: selectedIndex,
            labelType: labelType,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.chat_bubble_outline),
                label: Text(tr(LocaleKeys.chat)),
                padding: EdgeInsets.only(top: 5, bottom: 5),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history),
                label: Text(tr(LocaleKeys.history)),
                padding: EdgeInsets.only(bottom: 5),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: Text(tr(LocaleKeys.settings)),
                padding: EdgeInsets.only(bottom: 5),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.dehaze),
          onPressed: () {
            /// 更改桌面端导航栏的标签显示状态
            setState(() {
              labelType = labelType == NavigationRailLabelType.all
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all;
            });
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }

  /// IndexedStack 用于切换页面
  Widget _buildIndexedStack() {
    return IndexedStack(
      index: selectedIndex,
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
    );
  }

  /// 移动端布局
  Widget _mobileLayout() {
    return Scaffold(
      body: _buildIndexedStack(),
      bottomNavigationBar: _mobileBottomNavigationBar(),
    );
  }

  /// 桌面端布局
  Widget _desktopLayout() {
    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          _desktopNavigationRail(),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _buildIndexedStack(),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 根据当前应用的宽度来决定使用哪种布局
    final double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      // 如果宽度小于600dp，则使用移动端布局
      return _mobileLayout();
    } else {
      // 否则使用桌面端布局
      return _desktopLayout();
    }
  }
}
