import 'package:flutter/material.dart';

class AppThemes {
  // 获取亮主题
  static ThemeData get lightTheme {
    return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 171, 194, 235)));
  }

  // 获取暗主题
  static ThemeData get darkTheme {
    return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 17, 95, 230),
            brightness: Brightness.dark));
  }
}
