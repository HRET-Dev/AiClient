import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/pages/chat/chat_page.dart';
import 'package:ai_client/pages/chat/chat_provider.dart';
import 'package:ai_client/pages/history/history_list.dart';
import 'package:ai_client/pages/settings/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageProvider extends ChangeNotifier {
  /// 导航栏当前选中项
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  /// 导航栏标签显示状态
  NavigationRailLabelType _labelType = NavigationRailLabelType.all;
  NavigationRailLabelType get labelType => _labelType;

  /// 侧边栏宽度
  double _sidebarWidth = 165;
  double get sidebarWidth => _sidebarWidth;

  /// 侧边栏最小宽度
  final double minSidebarWidth = 80;

  /// 侧边栏最大宽度
  final double maxSidebarWidth = 400;

  /// 侧边栏是否显示
  bool _isSidebarVisible = true;
  bool get isSidebarVisible => _isSidebarVisible;

  /// 侧边栏之前的宽度（用于隐藏后恢复）
  double _previousSidebarWidth = 165;
  double get previousSidebarWidth => _previousSidebarWidth;

  /// 设置选中的导航项
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  /// 设置侧边栏可见性
  void setSidebarVisibility(bool isVisible) {
    if (!isVisible) {
      _previousSidebarWidth = _sidebarWidth;
    } else {
      _sidebarWidth = _previousSidebarWidth;
    }
    _isSidebarVisible = isVisible;
    notifyListeners();
  }

  /// 调整侧边栏宽度
  void adjustSidebarWidth(double delta) {
    _sidebarWidth += delta;

    // 限制侧边栏宽度在最小值和最大值之间
    if (_sidebarWidth < minSidebarWidth) {
      _sidebarWidth = minSidebarWidth;
    } else if (_sidebarWidth > maxSidebarWidth) {
      _sidebarWidth = maxSidebarWidth;
    }

    // 添加安全距离检测，确保组件不会超出可见范围
    final double safeMinWidth = 180; // 安全最小宽度，确保UI元素不会重叠或变形
    if (_sidebarWidth < safeMinWidth) {
      // 当接近安全最小宽度时，增加阻尼效果，使拖动变得更困难
      double dampingFactor = 0.3; // 阻尼系数
      _sidebarWidth =
          safeMinWidth + (_sidebarWidth - safeMinWidth) * dampingFactor;
    }

    notifyListeners();
  }

  /// 计算移动端抽屉宽度
  double calculateDrawerWidth(BuildContext context) {
    var drawerWidth = MediaQuery.of(context).size.width * 0.8;

    // 判断是否大于最大宽度
    if (drawerWidth > maxSidebarWidth) {
      // 如果超过最大宽度，使用最大宽度
      drawerWidth = maxSidebarWidth;
    }

    return drawerWidth;
  }
}

class HomePageState extends State<HomePage> {
  /// 用于访问 ChatPage 的状态
  final GlobalKey<ChatPageState> chatPageKey = GlobalKey<ChatPageState>();

  /// homePageProvider 统一管理状态
  late HomePageProvider homeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 初始化HomePageProvider
    homeProvider = Provider.of<HomePageProvider>(context);
  }

  /// 移动端底部导航栏 NavigationBar
  // Widget _mobileBottomNavigationBar() {
  //   return NavigationBar(
  //     selectedIndex: selectedIndex,
  //     onDestinationSelected: (int index) {
  //       setState(() {
  //         selectedIndex = index;
  //       });
  //     },
  //     destinations: [
  //       NavigationDestination(
  //         icon: Icon(
  //           Icons.chat_bubble_outline,
  //           size: 18,
  //         ),
  //         label: tr(LocaleKeys.chat),
  //       ),
  //       NavigationDestination(
  //         icon: Icon(
  //           Icons.history,
  //           size: 20,
  //         ),
  //         label: tr(LocaleKeys.history),
  //       ),
  //       NavigationDestination(
  //         icon: Icon(
  //           Icons.settings,
  //           size: 20,
  //         ),
  //         label: tr(LocaleKeys.settings),
  //       ),
  //     ],
  //   );
  // }

  /// 桌面端侧边导航栏 NavigationRail
  Widget _desktopNavigationRail() {
    /// 获取全局的聊天提供器
    final ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: false);

    // 如果侧边栏不可见，返回一个最小化的控制栏
    if (!homeProvider.isSidebarVisible) {
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
                  homeProvider.setSidebarVisibility(true);
                  homeProvider._sidebarWidth =
                      homeProvider.previousSidebarWidth;
                },
                tooltip: tr(LocaleKeys.sidebarShow),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: homeProvider.sidebarWidth,
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
                // 切换到聊天页面
                homeProvider.setSelectedIndex(0);
                chatProvider.clearChat();
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
                    homeProvider._previousSidebarWidth =
                        homeProvider.sidebarWidth;
                    homeProvider.setSidebarVisibility(false);
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
    final isSelected = homeProvider.selectedIndex == index;

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
        homeProvider.setSelectedIndex(index);
      },
    );
  }

  /// IndexedStack 用于切换页面
  Widget _buildIndexedStack() {
    return IndexedStack(
      index: homeProvider.selectedIndex,
      children: [
        ChatPage(key: chatPageKey), // 聊天
        HistoryList(), // 历史
        SettingsPage(), // 设置
      ],
    );
  }

  /// 移动端布局
  Widget _mobileLayout() {
    // 获取当前主题信息
    final ThemeData theme = Theme.of(context);
    // 创建日期格式化器
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    /// 获取全局的聊天提供器
    final ChatProvider chatProvider = Provider.of<ChatProvider>(context);

    // 计算抽屉宽度为屏幕宽度的80%
    var drawerWidth = MediaQuery.of(context).size.width * 0.8;

    // 判断是否大于最大宽度
    if (drawerWidth > homeProvider.maxSidebarWidth) {
      // 如果超过最大宽度，使用最大宽度
      drawerWidth = homeProvider.maxSidebarWidth;
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 38,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatProvider.chatSessionName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(width: 2),
            if (chatProvider.currentModel.isNotEmpty &&
                chatProvider.currentModel != '')
              Text(
                chatProvider.currentModel,
                style: TextStyle(fontSize: 12),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, size: 16),
            onPressed: () {
              chatPageKey.currentState?.showSettingsDialog();
            },
          ),
          IconButton(
            icon: Icon(Icons.add, size: 18),
            onPressed: () {
              chatProvider.clearChat();
            },
            tooltip: tr(LocaleKeys.chatPageNewChat),
          ),
        ],
      ),
      drawer: SafeArea(
        child: SizedBox(
          width: drawerWidth,
          child: Drawer(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  height: 50,
                  width: double.infinity,
                  color: theme.colorScheme.surface,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.bolt,
                          size: 20, color: theme.colorScheme.primary),
                      SizedBox(width: 8),
                      Text(
                        LocaleKeys.sidebarAppName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ).tr(),
                    ],
                  ),
                ),
                Divider(height: 1),
                // 主要导航选项
                ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.chat_bubble_outline,
                    color: homeProvider.selectedIndex == 0
                        ? theme.colorScheme.primary
                        : null,
                    size: 20,
                  ),
                  title: Text(
                    LocaleKeys.chat,
                    style: TextStyle(
                      color: homeProvider.selectedIndex == 0
                          ? theme.colorScheme.primary
                          : null,
                      fontWeight: homeProvider.selectedIndex == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ).tr(),
                  selected: homeProvider.selectedIndex == 0,
                  onTap: () {
                    homeProvider.setSelectedIndex(0);
                    Navigator.pop(context); // 关闭抽屉
                  },
                ),
                // 历史选项
                ListTile(
                  dense: true,
                  leading: Icon(Icons.history, size: 20),
                  title: Text(LocaleKeys.history).tr(),
                  onTap: () {
                    // 先关闭抽屉
                    Navigator.pop(context);
                    // 然后导航到历史页面
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            toolbarHeight: 48,
                            title: Text(LocaleKeys.history,
                                    style: TextStyle(fontSize: 16))
                                .tr(),
                            leading: BackButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          body: HistoryList(
                            isFromNavigation: true,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // 设置选项
                ListTile(
                  dense: true,
                  leading: Icon(Icons.settings, size: 20),
                  title: Text(LocaleKeys.settings).tr(),
                  onTap: () {
                    // 先关闭抽屉
                    Navigator.pop(context);
                    // 然后导航到设置页面
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            toolbarHeight: 48,
                            title: Text(tr(LocaleKeys.settings),
                                style: TextStyle(fontSize: 16)),
                            leading: BackButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          body: SettingsPage(
                            isFromNavigation: true,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Divider(),
                // 所有对话标题
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      LocaleKeys.sidebarAllChats,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                    ).tr(),
                  ),
                ),
                // 对话列表
                Expanded(
                  child: FutureBuilder<List<ChatSession>>(
                    future: chatProvider.chatSessionService.getAllSessions(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('加载失败: ${snapshot.error}'));
                      } else {
                        final sessions = snapshot.data!;
                        return ListView.builder(
                          itemCount: sessions.length,
                          itemBuilder: (context, index) {
                            final chatSession = sessions[index];
                            // 检查是否为当前选中的会话
                            final bool isCurrentSession =
                                chatProvider.chatSessionId == chatSession.id;
                            return ListTile(
                              dense: true,
                              leading: Icon(Icons.chat_outlined, size: 18),
                              title: Text(
                                chatSession.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // 当前会话高亮显示
                                  color: isCurrentSession
                                      ? theme.colorScheme.primary
                                      : null,
                                ),
                              ),
                              subtitle: Text(
                                dateFormat.format(chatSession.updatedTime),
                                style: TextStyle(fontSize: 12),
                              ),
                              // 当前会话使用不同的背景色
                              tileColor: isCurrentSession
                                  ? theme.colorScheme.primaryContainer
                                      .withValues(alpha: 0.2)
                                  : null,
                              onTap: () {
                                // 加载历史会话
                                chatProvider.loadSession(chatSession);
                                // 判断是否为当前聊天页面
                                if (homeProvider.selectedIndex != 0) {
                                  // 切换到聊天页面
                                  homeProvider.setSelectedIndex(0);
                                }
                                // 关闭抽屉
                                Navigator.pop(context);
                              },
                              onLongPress: () async {
                                // 删除确认对话框
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(LocaleKeys.confirmDelete).tr(),
                                    content:
                                        Text(LocaleKeys.confirmDeleteMessage)
                                            .tr(),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text(LocaleKeys.cancel).tr(),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(LocaleKeys.confirm).tr(),
                                      ),
                                    ],
                                  ),
                                );

                                // 判断是否确认
                                if (confirm != true) return;

                                // 删除当前会话
                                await chatProvider.chatSessionService
                                    .deleteSession(chatSession.id);

                                // 刷新抽屉
                                setState(() {});

                                // 如果当前正在显示被删除的会话，则清空聊天
                                if (chatProvider.chatSessionId ==
                                    chatSession.id) {
                                  chatProvider.clearChat();
                                }
                              },
                              // 添加删除按钮
                              trailing: IconButton(
                                icon: Icon(Icons.delete, size: 18),
                                onPressed: () async {
                                  // 删除确认对话框
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title:
                                          Text(LocaleKeys.confirmDelete).tr(),
                                      content:
                                          Text(LocaleKeys.confirmDeleteMessage)
                                              .tr(),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text(LocaleKeys.cancel).tr(),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text(LocaleKeys.confirm).tr(),
                                        ),
                                      ],
                                    ),
                                  );

                                  // 判断是否确认
                                  if (confirm != true) return;

                                  // 删除当前会话
                                  await chatProvider.chatSessionService
                                      .deleteSession(chatSession.id);

                                  // 刷新抽屉
                                  setState(() {});

                                  // 如果当前正在显示被删除的会话，则清空聊天
                                  if (chatProvider.chatSessionId ==
                                      chatSession.id) {
                                    chatProvider.clearChat();
                                  }
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ChatPage(key: chatPageKey),
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
            if (homeProvider.isSidebarVisible)
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  homeProvider.adjustSidebarWidth(details.delta.dx);
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
