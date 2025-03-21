import 'package:flutter/material.dart';

/// 应用主题工具类，提供统一的主题颜色访问方法
class AppTheme {
  /// 获取应用主题颜色
  static Color getAppColor(BuildContext context) {
    // 判断当前是否是暗色主题
    if (Theme.of(context).brightness == Brightness.dark) {
      return Theme.of(context).colorScheme.primaryContainer;
    }
    return Theme.of(context).colorScheme.primary;
  }

  /// 获取应用主题反向颜色
  static Color getAppInverseColor(BuildContext context) {
    return Theme.of(context).colorScheme.onPrimaryContainer;
  }
}
