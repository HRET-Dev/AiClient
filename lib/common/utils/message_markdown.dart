import 'package:ai_client/generated/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_highlighter/themes/atom-one-light.dart';
import 'package:flutter_highlighter/themes/dracula.dart';
import 'package:flutter_highlighter/themes/github.dart';
import 'package:flutter_highlighter/themes/vs.dart';
import 'package:flutter_highlighter/themes/vs2015.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

/// Markdown消息渲染器
class MessageMarkdown extends StatefulWidget {
  MessageMarkdown({
    super.key,
    required this.content,
    this.theme,
  });

  // 消息内容
  final String content;

  /// 主题名称
  final String? theme;

  // 定义可用的代码主题映射
  static final Map<String, Map<String, dynamic>> availableThemes = {
    '默认': {
      'light': atomOneLightTheme,
      'dark': atomOneDarkTheme,
    },
    'GitHub': {
      'light': githubTheme,
      'dark': draculaTheme,
    },
    'Visual Studio': {
      'light': vsTheme,
      'dark': vs2015Theme,
    },
  };

  @override
  State<MessageMarkdown> createState() => _MarkdownGeneratorState();
}

/// Markdown消息渲染器状态管理
class _MarkdownGeneratorState extends State<MessageMarkdown> {
  /// 复制状态 true: 已复制 false: 未复制
  bool _copied = false;

  /// 默认主题样式
  final String _defaultTheme = '默认';

  /// 创建透明背景的代码主题
  Map<String, TextStyle> _createTransparentTheme(
      Map<String, TextStyle> baseTheme) {
    final newTheme = Map<String, TextStyle>.from(baseTheme);
    // 移除根元素的背景色设置
    if (newTheme.containsKey('root')) {
      final rootStyle = newTheme['root']!;
      newTheme['root'] =
          rootStyle.copyWith(backgroundColor: Colors.transparent);
    }
    return newTheme;
  }

  @override
  Widget build(BuildContext context) {
    // 获取当前主题
    final ThemeData theme = Theme.of(context);

    // 根据当前亮暗模式选择合适的代码主题
    final String brightness =
        theme.brightness == Brightness.dark ? 'dark' : 'light';

    // 主题安全获取
    String themeKey = widget.theme ?? _defaultTheme;
    if (!MessageMarkdown.availableThemes.containsKey(themeKey)) {
      themeKey = _defaultTheme;
    }

    // 获取正确类型的代码主题并应用透明背景
    final Map<String, TextStyle> codeTheme = _createTransparentTheme(
        MessageMarkdown.availableThemes[themeKey]![brightness]
            as Map<String, TextStyle>);

    return Material(
      // 添加背景色，使用与代码块相似的颜色
      color: theme.colorScheme.onInverseSurface,
      // 保留原有的圆角设置
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      // 添加内边距，使内容不会紧贴边缘
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        // 利用SelectionArea包裹GptMarkdown，实现文本选择
        child: SelectionArea(
          // 渲染消息内容
          child: GptMarkdown(
            widget.content, // 消息内容
            codeBuilder: (context, name, code, closed) {
              // 为每个代码块创建一个新的ScrollController
              final ScrollController scrollController = ScrollController();

              return Material(
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                // 利用Column布局代码块的标题栏和内容
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Material(
                      // 使用更深的颜色作为标题栏背景
                      color: theme.colorScheme.secondaryContainer,
                      // 添加圆角，但只设置顶部左右两个角为圆角
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 4,
                            ),
                            child: Text(
                              name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.onSurface,
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal),
                            ),
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: code),
                              ).then((value) {
                                setState(() {
                                  _copied = true;
                                });
                              });
                              await Future.delayed(const Duration(seconds: 2));
                              setState(() {
                                _copied = false;
                              });
                            },
                            icon: Icon(
                              (_copied) ? Icons.done : Icons.paste_outlined,
                              size: 15,
                            ),
                            label: Text((_copied)
                                    ? LocaleKeys.copySuccess
                                    : LocaleKeys.copy)
                                .tr(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // 使用Scrollbar包裹SingleChildScrollView，添加滚动条指示器
                    Scrollbar(
                      // 设置滚动条始终可见
                      thumbVisibility: true,
                      // 设置滚动条厚度
                      thickness: 6,
                      // 设置滚动条半径
                      radius: const Radius.circular(3),
                      // 使用当前代码块的专用控制器
                      controller: scrollController,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(10),
                        // 使用相同的控制器
                        controller: scrollController,
                        // 利用HighlightView渲染代码块
                        child: HighlightView(
                          code,
                          // 代码块主题
                          theme: codeTheme,
                          // 代码块语言
                          language: name.toLowerCase(),
                          // 代码块内边距
                          padding: const EdgeInsets.all(5),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
