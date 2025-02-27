import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'app.dart';

void main() async {
  if (kIsWeb) {
    // Web 平台使用 sqfLite_common_ffi_web 的工厂
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    // 显式初始化 SqlLite FFI 环境
    sqfliteFfiInit();
    // 初始化 FFI 数据库工厂
    databaseFactory = databaseFactoryFfi;
  }

  // 初始化Easy_Localization库
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('zh', 'CN'),
          Locale('en', 'US'),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale('zh', 'CN'),
        child: App()),
  );
}
