import 'package:ai_client/generated/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 语言设置
class LanguageSettings {
  // 语言设置信息
  static TDCell buildLanguageSettings(BuildContext context) {
    return TDCell(
      arrow: false,
      title: tr(LocaleKeys.settingPageLanguageSettingLanguageButtonText),
      leftIcon: TDIcons.earth,
      onClick: (text) {
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.center,
            builder: (context) {
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
                    var language = context.supportedLocales[index].toString();
                    var title = tr(
                        '${LocaleKeys.settingPageLanguageSettingLanguageList}.$language');

                    return TDRadio(
                      id: '$index',
                      title: title,
                      size: TDCheckBoxSize.large,
                    );
                  },
                  itemCount: context.supportedLocales.length,
                ),
                onRadioGroupChange: (index) {
                  context
                      .setLocale(context.supportedLocales[int.parse(index!)]);
                  Navigator.of(context).pop();
                },
              );
            }));
      },
    );
  }
}
