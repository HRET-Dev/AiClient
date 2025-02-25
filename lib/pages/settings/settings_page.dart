import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// 设置菜单
  Widget _buildSettingsList(BuildContext context) {
    return TDCellGroup(
      theme: TDCellGroupTheme.cardTheme,
      cells: [
        // 语言设置
        TDCell(
          arrow: false,
          title: tr('settings_page.language_button_text'),
          leftIcon: TDIcons.earth,
          onClick: (text) {
            Navigator.of(context).push(TDSlidePopupRoute(
                modalBarrierColor: TDTheme.of(context).fontGyColor2,
                slideTransitionFrom: SlideTransitionFrom.center,
                builder: (context) {
                  return TDRadioGroup(
                    selectId: 'index:0',
                    passThrough: true,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var title = '单选';
                        return TDRadio(
                          id: 'index:$index',
                          title: title,
                          size: TDCheckBoxSize.large,
                        );
                      },
                      itemCount: 4,
                    ),
                  );
                }));
          },
        ),
      ],
    );
  }

  /// 切换语言
  void _changeLocale() async {
    // 获取当前语言在支持的语言列表中的索引
    final currentIndex = context.supportedLocales.indexOf(context.locale);

    // 计算下一个语言的索引，使用取模运算确保循环切换
    final nextIndex = (currentIndex + 1) % context.supportedLocales.length;

    // 切换到下一个语言
    await context.setLocale(context.supportedLocales[nextIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 确保键盘弹出时布局调整
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Settings").tr(),
            ),
            _buildSettingsList(context)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeLocale,
        tooltip: '切换语言',
        child: Icon(TDIcons.earth),
      ),
    );
  }
}
