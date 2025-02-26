import 'package:ai_client/generated/locale_keys.dart';
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
          title: tr(LocaleKeys.settingsPageLanguageButtonText),
          leftIcon: TDIcons.earth,
          onClick: (text) {
            Navigator.of(context).push(TDSlidePopupRoute(
                modalBarrierColor: TDTheme.of(context).fontGyColor2,
                slideTransitionFrom: SlideTransitionFrom.center,
                builder: (context) {
                  // 获取当前语言在支持的语言列表中的索引
                  final currentIndex =
                      context.supportedLocales.indexOf(context.locale);

                  return TDRadioGroup(
                    selectId: '$currentIndex',
                    passThrough: true,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // 获取语言名称
                        var language =
                            context.supportedLocales[index].toString();

                        // 匹配语言对应的名字
                        var title = tr(
                            '${LocaleKeys.settingsPageLanguageList}.$language');

                        // 生成单选框
                        return TDRadio(
                          id: '$index',
                          title: title,
                          size: TDCheckBoxSize.large,
                        );
                      },
                      itemCount: context.supportedLocales.length, // 本地语言数量
                    ),
                    onRadioGroupChange: (index) {
                      // 根据传递的索引切换对应的语言信息
                      context.setLocale(
                          context.supportedLocales[int.parse(index!)]);
                      // 关闭弹窗
                      Navigator.of(context).pop();
                    },
                  );
                }));
          },
        ),
      ],
    );
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
              child: Text(LocaleKeys.settings).tr(),
            ),
            _buildSettingsList(context)
          ],
        ),
      ),
    );
  }
}
