import 'package:flutter/material.dart';

/// 加载指示器工具类
class LoadingIndicator {
  /// 构建加载指示器
  static Widget buildLoadingIndicator(BuildContext context) {
    return Center(
      child: SizedBox(
        // 设置容器高度为可用高度（屏幕高度减去 AppBar 高度）
        height:
            MediaQuery.of(context).size.height - AppBar().preferredSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  '加载中…',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
