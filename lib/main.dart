import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';

void main() async {
  // 初始化Easy_Localization库
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // 仅在桌面平台上初始化 window_manager
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    // 窗口设置
    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 630),
      // 初始窗口大小
      minimumSize: Size(360, 630),
      // 最小窗口大小
      center: true,
      // 窗口居中显示
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
