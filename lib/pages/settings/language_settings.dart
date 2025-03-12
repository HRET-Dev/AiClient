import 'package:ai_client/generated/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// 语言设置
class LanguageSettings {
  // 语言设置信息
  static Widget buildLanguageSettings(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(tr(LocaleKeys.settingPageLanguageSettingLanguageButtonText)),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            final currentIndex =
                context.supportedLocales.indexOf(context.locale);

            return AlertDialog(
              title: Text(
                  tr(LocaleKeys.settingPageLanguageSettingLanguageButtonText)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: context.supportedLocales.length,
                      itemBuilder: (context, index) {
                        var language =
                            context.supportedLocales[index].toString();
                        var title = tr(
                            '${LocaleKeys.settingPageLanguageSettingLanguageList}.$language');

                        return RadioListTile(
                          title: Text(title),
                          value: index,
                          groupValue: currentIndex,
                          onChanged: (value) {
                            if (value != null) {
                              // 关闭对话框
                              Navigator.pop(context);
                              // 设置语言
                              context
                                  .setLocale(context.supportedLocales[value]);
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
