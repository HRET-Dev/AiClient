import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/pages/chat/chat_page.dart';
import 'package:ai_client/pages/history/history_list.dart';
import 'package:ai_client/pages/settings/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  /// 导航栏当前选中项
  int selectedIndex = 0;

  /// 用于访问 ChatPage 的状态
  final GlobalKey<ChatPageState> chatPageKey = GlobalKey<ChatPageState>();

  /// 导航栏标签显示状态
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  /// 侧边栏宽度
  double sidebarWidth = 165;

  /// 侧边栏最小宽度
  final double minSidebarWidth = 80;

  /// 侧边栏最大宽度
  final double maxSidebarWidth = 400;

  /// 侧边栏是否显示
  bool isSidebarVisible = true;

  /// 侧边栏之前的宽度（用于隐藏后恢复）
  double previousSidebarWidth = 165;

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
    // 如果侧边栏不可见，返回一个最小化的控制栏
    if (!isSidebarVisible) {
      return Container(
        width: 55,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            right: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    isSidebarVisible = true;
                    sidebarWidth = previousSidebarWidth;
                  });
                },
                tooltip: tr(LocaleKeys.sidebarShow),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // 顶部标题
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.bolt, size: 24),
                SizedBox(width: 8),
                Text(
                  tr(LocaleKeys.sidebarAppName),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 新建聊天按钮
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  // 切换到聊天页面
                  selectedIndex = 0;
                });
                // 使用 GlobalKey 访问 ChatPage 的状态
                chatPageKey.currentState?.clearChat();
              },
              icon: Icon(Icons.add),
              label: Text(tr(LocaleKeys.chatPageNewChat)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // 导航选项
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              children: [
                // 聊天选项
                _buildNavItem(
                  icon: Icons.chat_bubble_outline,
                  label: tr(LocaleKeys.chat),
                  index: 0,
                ),
                // 历史选项
                _buildNavItem(
                  icon: Icons.history,
                  label: tr(LocaleKeys.history),
                  index: 1,
                ),
                // 设置选项
                _buildNavItem(
                  icon: Icons.settings,
                  label: tr(LocaleKeys.settings),
                  index: 2,
                ),
              ],
            ),
          ),
          // 底部控制按钮区域
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 隐藏侧边栏按钮
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      previousSidebarWidth = sidebarWidth;
                      isSidebarVisible = false;
                    });
                  },
                  tooltip: tr(LocaleKeys.sidebarHide),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建导航项
  Widget _buildNavItem(
      {required IconData icon, required String label, required int index}) {
    final isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }

  /// IndexedStack 用于切换页面
  Widget _buildIndexedStack() {
    return IndexedStack(
      index: selectedIndex,
      children: [
        ChatPage(key: chatPageKey), // 聊天
        HistoryList(), // 历史
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
            // 左侧导航栏
            _desktopNavigationRail(),
            // 如果侧边栏可见，添加一个可拖动的分隔线
            if (isSidebarVisible)
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    sidebarWidth += details.delta.dx;
                    // 限制侧边栏宽度在最小值和最大值之间
                    if (sidebarWidth < minSidebarWidth) {
                      sidebarWidth = minSidebarWidth;
                    } else if (sidebarWidth > maxSidebarWidth) {
                      sidebarWidth = maxSidebarWidth;
                    }

                    // 添加安全距离检测，确保组件不会超出可见范围
                    // 为顶部标题、按钮和导航项预留足够空间
                    final double safeMinWidth = 180; // 安全最小宽度，确保UI元素不会重叠或变形
                    if (sidebarWidth < safeMinWidth) {
                      // 当接近安全最小宽度时，增加阻尼效果，使拖动变得更困难
                      double dampingFactor = 0.3; // 阻尼系数
                      sidebarWidth = safeMinWidth +
                          (sidebarWidth - safeMinWidth) * dampingFactor;
                    }
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeftRight,
                  child: Container(
                    width: 8,
                    color: Colors.transparent,
                    height: double.infinity,
                  ),
                ),
              ),
            // 右侧内容区域
            Expanded(
              child: Container(
                child: _buildIndexedStack(),
              ),
            ),
          ],
        ),
      ),
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
