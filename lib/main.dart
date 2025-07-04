import 'dart:io';

import 'package:ai_client/pages/chat/chat_provider.dart';
import 'package:ai_client/pages/home_page.dart';
import 'package:ai_client/services/hive_storage_service.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // 初始化Easy_Localization库
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // 初始化Hive数据库
  await HiveStorageService.init();

  // 判断是否为 Web 平台
  if (!kIsWeb) {
    // 仅在桌面平台上初始化 window_manager
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await windowManager.ensureInitialized();

      // 窗口设置
      WindowOptions windowOptions = const WindowOptions(
        // 初始窗口大小
        size: Size(800, 630),
        // 最小窗口大小
        minimumSize: Size(330, 400),
        // 窗口居中显示
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
      );

      // 应用窗口设置
      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('zh', 'CN'),
          Locale('zh', 'TW'),
          Locale('en', 'US'),
          Locale('ja', 'JP'),
          Locale('ko', 'KR'),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('zh', 'CN'),
        child: App()),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      // 主题模式
      themeMode: ThemeMode.system,
      // 主题
      theme: ShadThemeData(
          colorScheme: const ShadZincColorScheme.light(),
          brightness: Brightness.light),
      // 暗黑主题
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadZincColorScheme.dark(),
      ),
      // 构建 MaterialApp
      appBuilder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => HomePageProvider()),
            ChangeNotifierProvider(create: (_) => ChatProvider()),
          ],
          child: MaterialApp(
            // 初始化 BotToast, 用于全局提示
            builder: BotToastInit(),
            // 路由监听器
            navigatorObservers: [
              // BotToast路由观察者
              BotToastNavigatorObserver(),
            ],

            // 多语言 配置Easy_Localization
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,

            home: HomePage(),
          ),
        );
      },
    );
  }
}
