import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/pages/settings/apis/api_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'api_insert.dart';

/// API设置
class ApiSettings extends StatefulWidget {
  // API设置信息
  static Widget buildApiSettings(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.cloud),
      title: Text(tr(LocaleKeys.settingPageApiSettingApiManger)),
      onTap: () {
        // 点击事件，跳转到 API 列表页面
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ApiSettings()),
        );
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _ApiSettings();
}

class _ApiSettings extends State<ApiSettings> {
  /// 添加按钮
  Widget _addButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: tr(LocaleKeys.settingPageApiSettingAddApi),
      onPressed: () {
        // 跳转到 API 添加页面
        Navigator.of(context).push(TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.center,
            builder: (context) {
              return ApiInsert();
            },
            close: () {
              // 关闭前刷新列表
              setState(() {});
            }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
        toolbarHeight: 48,
        title: Text(
          LocaleKeys.settingPageApiSettingApiManger,
          style: const TextStyle(fontSize: 18),
        ).tr(),
        actions: [
          // 添加按钮
          _addButton(),
        ],
      ),
      body: Column(
        children: [
          // API 列表
          ApiList(key: UniqueKey()),
        ],
      ),
    );
  }
}
