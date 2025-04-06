import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/pages/settings/apis/api_settings.dart';
import 'package:ai_client/pages/settings/language_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  /// 是否是从页面导航过来的
  final bool isFromNavigation;

  const SettingsPage({this.isFromNavigation = false});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// 设置菜单
  Widget _buildSettingsList(BuildContext context) {
    return ListView(
      children: [
        // API 管理
        ApiSettings.buildApiSettings(context),
        // 分割线
        const Divider(
          height: 1,
          thickness: 1,
        ),
        // 语言设置
        LanguageSettings.buildLanguageSettings(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (!widget.isFromNavigation)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(LocaleKeys.settings).tr(),
              ),
            Expanded(child: _buildSettingsList(context)),
          ],
        ),
      ),
    );
  }
}
