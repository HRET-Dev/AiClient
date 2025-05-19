import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

/// Toast工具类
class Toast {
  // 工具类无需实例化 设置构造私有化
  Toast._();

  /// 显示一个标准的自定义 Toast 提示.
  ///
  /// 该方法允许通过参数自定义 Toast 的内容、样式和行为.
  ///
  /// 返回一个 [CancelFunc] 函数，调用此函数可以手动提前关闭该 Toast.
  ///
  /// 参数说明：
  ///
  /// - `message`：需要在 Toast 中显示的文本内容。
  /// - `crossPage`：指示 Toast 是否可以跨越多个页面（路由）显示，默认为 `false`.
  /// - `align`：Toast 在屏幕上的对齐方式，默认为 `Alignment(0.0, -0.8)`，即屏幕顶部中央.
  /// - `duration`：Toast 显示的持续时间，默认为 `Duration(seconds: 3)`.
  /// - `onClose`：当 Toast 关闭时执行的回调函数.
  /// - `icon`：在消息文本前显示的图标（可选）.
  /// - `textColor`：消息文本的颜色（可选）.
  /// - `defaultIconColor`：图标的默认颜色（可选，仅当提供了 `icon` 时生效）.
  /// - `iconBackgroundColor`：图标背景的颜色（可选，仅当提供了 `icon` 时生效）.
  static CancelFunc showToast(
    String message, {
    bool? crossPage,
    Alignment? align,
    Duration? duration,
    VoidCallback? onClose,
    Icon? icon,
    Color? textColor,
    Color? defaultIconColor,
    Color? iconBackgroundColor,
  }) {
    return BotToast.showCustomText(
      // 是否跨页面显示
      crossPage: crossPage ?? false,
      // 是否只显示一个
      onlyOne: true,
      // 显示位置
      align: align ?? const Alignment(0.0, -0.8),
      // 显示时长
      duration: duration ?? const Duration(seconds: 3),
      // 关闭回调
      onClose: onClose,
      // Toast样式内容
      toastBuilder: (cancel) {
        final List<Widget> children = [];

        // 添加图标
        if (icon != null) {
          children.add(Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: iconBackgroundColor ?? Colors.black12,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconTheme(
                data: IconThemeData(size: 16, color: defaultIconColor),
                child: icon),
          ));
        }

        // 添加消息内容
        children.add(Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: icon == null ? 5 : 0,
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ),
              strutStyle: const StrutStyle(leading: 0, forceStrutHeight: true),
            ),
          ),
        ));

        return Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // 宽度刚好包裹内容
            mainAxisAlignment: MainAxisAlignment.center, // 横向居中（视觉对称）
            crossAxisAlignment: CrossAxisAlignment.center, // 垂直方向对齐
            children: children,
          ),
        );
      },
    );
  }

  /// 成功类消息
  ///
  /// 参数:
  /// - `message`: 需要在 Toast 中显示的文本内容.
  /// - `crossPage`: 指示 Toast 是否可以跨越多个页面（路由）显示.
  /// - `align`: Toast 在屏幕上的对齐方式.
  /// - `duration`: Toast 显示的持续时间.
  /// - `onClose`: 当 Toast 关闭时执行的回调函数.
  static CancelFunc showSuccess(
    String message, {
    bool? crossPage,
    Alignment? align,
    Duration? duration,
    VoidCallback? onClose,
  }) {
    return showToast(
      message,
      crossPage: crossPage,
      align: align,
      duration: duration,
      onClose: onClose,
      icon: const Icon(Icons.check_circle_outline),
      defaultIconColor: const Color(0xFF4CAF50), // Green
      iconBackgroundColor: const Color(0xFFE8F5E9), // Light Green
      textColor: Colors.black87,
    );
  }

  /// 提示类消息
  ///
  /// 参数与 [showSuccess] 类似.
  static CancelFunc showInfo(
    String message, {
    bool? crossPage,
    Alignment? align,
    Duration? duration,
    VoidCallback? onClose,
  }) {
    return showToast(
      message,
      crossPage: crossPage,
      align: align,
      duration: duration,
      onClose: onClose,
      icon: const Icon(Icons.info_outline),
      defaultIconColor: const Color(0xFF2196F3), // Blue
      iconBackgroundColor: const Color(0xFFE3F2FD), // Light Blue
      textColor: Colors.black87,
    );
  }

  /// 警告类消息
  ///
  /// 参数与 [showSuccess] 类似.
  static CancelFunc showWarning(
    String message, {
    bool? crossPage,
    Alignment? align,
    Duration? duration,
    VoidCallback? onClose,
  }) {
    return showToast(
      message,
      crossPage: crossPage,
      align: align,
      duration: duration,
      onClose: onClose,
      icon: const Icon(Icons.warning_amber_outlined),
      defaultIconColor: const Color(0xFFFF9800), // Orange
      iconBackgroundColor: const Color(0xFFFFF3E0), // Light Orange
      textColor: Colors.black87,
    );
  }

  /// 错误类消息
  ///
  /// 参数与 [showSuccess] 类似.
  static CancelFunc showError(
    String message, {
    bool? crossPage,
    Alignment? align,
    Duration? duration,
    VoidCallback? onClose,
  }) {
    return showToast(
      message,
      crossPage: crossPage,
      align: align,
      duration: duration,
      onClose: onClose,
      icon: const Icon(Icons.error_outline),
      defaultIconColor: const Color(0xFFF44336), // Red
      iconBackgroundColor: const Color(0xFFFFEBEE), // Light Red
      textColor: Colors.black87,
    );
  }

  /// 加载中消息
  static CancelFunc showLoading() {
    return BotToast.showCustomLoading(
      toastBuilder: (cancelFunc) {
        return Container(
          child: Text("data"),
        );
      },
    );
  }

  /// 横幅消息
  static void showNotification() {}
}
