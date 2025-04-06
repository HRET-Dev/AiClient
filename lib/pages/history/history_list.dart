import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/pages/chat/chat_provider.dart';
import 'package:ai_client/pages/home_page.dart';
import 'package:ai_client/repositories/chat_message_repository.dart';
import 'package:ai_client/repositories/chat_session_repository.dart';
import 'package:ai_client/services/chat_session_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 历史记录列表
class HistoryList extends StatefulWidget {
  /// 是否是从页面导航过来的
  final bool isFromNavigation;

  HistoryList({this.isFromNavigation = false});

  @override
  HistoryListState createState() => HistoryListState();
}

/// 历史记录列表状态管理
class HistoryListState extends State<HistoryList> with WidgetsBindingObserver {
  // 数据源
  late final AppDatabase _appDatabase;

  /// 聊天会话 服务类
  late final ChatSessionService _chatSessionService;

  /// 聊天会话信息列表
  List<ChatSession> _chatSessions = [];

  /// 上次可见状态
  bool _wasVisible = false;

  @override
  void initState() {
    super.initState();
    // 初始化数据源
    _appDatabase = AppDatabase();
    // 初始化聊天会话 服务类
    _chatSessionService = ChatSessionService(
        ChatSessionRepository(_appDatabase),
        ChatMessageRepository(_appDatabase));
    // 初始化数据
    _initData();

    // 添加观察者
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // 移除观察者
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 当应用程序从后台恢复到前台时刷新数据
    if (state == AppLifecycleState.resumed) {
      _initData();
    }
  }

  /// 刷新历史记录列表
  void refreshHistoryList() {
    _initData();
  }

  /// 检查页面可见性并在可见时刷新数据
  void _checkVisibilityAndRefresh() {
    // 获取HomePageProvider
    final homePageProvider =
        Provider.of<HomePageProvider>(context, listen: false);
    // 检查当前是否为历史记录页面
    bool isVisible = homePageProvider.selectedIndex == 1;

    // 如果从不可见变为可见，则刷新数据
    if (isVisible && !_wasVisible) {
      _initData();
    }

    _wasVisible = isVisible;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在依赖变化时检查可见性
    _checkVisibilityAndRefresh();
  }

  /// 初始化数据
  void _initData() async {
    // 查询聊天会话信息列表
    List<ChatSession> chatSessions = await _chatSessionService.getAllSessions();
    if (mounted) {
      setState(() {
        // 设置聊天会话信息列表
        _chatSessions = chatSessions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 在每次构建时检查可见性
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibilityAndRefresh();
    });

    /// 获取全局的 ChatProvider
    final chatProvider = Provider.of<ChatProvider>(context);

    // 创建日期格式化器
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: _chatSessions.length,
          itemBuilder: (context, index) {
            // 获取当前索引的ChatSession对象
            final chatSession = _chatSessions[index];

            return Card(
              elevation: 5,
              clipBehavior: Clip.antiAlias,
              child: Material(
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text(
                    chatSession.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // 会话创建时间 格式为 2025-03-22 12:00:00
                  subtitle: Text(dateFormat.format(chatSession.updatedTime)),
                  trailing: Icon(Icons.arrow_forward_ios),
                  // 单击事件
                  onTap: () {
                    // 加载会话
                    chatProvider.loadSession(chatSession);

                    // 判断是否是从页面导航过来的
                    if (widget.isFromNavigation) {
                      // 如果是导航过来的，则返回
                      Navigator.of(context).pop();
                    } else {
                      // 否则使用原来的逻辑
                      // 获取HomePageProvider
                      final homePageProvider =
                          Provider.of<HomePageProvider>(context, listen: false);
                      // 切换到聊天页面
                      homePageProvider.setSelectedIndex(0);
                    }
                  },
                  // 长按事件
                  onLongPress: () async {
                    // 删除确认对话框
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(LocaleKeys.confirmDelete).tr(),
                        content: Text(LocaleKeys.confirmDeleteMessage).tr(),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(LocaleKeys.cancel).tr(),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(LocaleKeys.confirm).tr(),
                          ),
                        ],
                      ),
                    );

                    // 判断是否确认
                    if (confirm != true) return;

                    setState(() {
                      // 删除当前会话信息
                      _chatSessions.removeAt(index);
                      // 删除当前会话
                      _chatSessionService.deleteSession(chatSession.id);
                    });

                    // 判断是否已经挂载
                    if (mounted) {
                      chatProvider.clearChat();
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
