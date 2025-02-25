import 'package:ai_client/pages/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 配置Easy_Localization
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // 明亮主题
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent)),
      // 黑暗主题
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87)),
      // 主题模式
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}
