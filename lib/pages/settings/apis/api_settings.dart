import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/pages/settings/apis/api_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// API设置
class ApiSettings extends StatefulWidget {
  // API设置信息
  static TDCell buildApiSettings(BuildContext context) {
    return TDCell(
        arrow: false,
        title: tr(LocaleKeys.settingPageApiSettingApiManger),
        leftIcon: TDIcons.cloud,
        onClick: (text) {
          // 点击事件，跳转到 API 列表页面
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ApiSettings()),
          );
        });
  }

  @override
  State<StatefulWidget> createState() => _ApiSettings();
}

class _ApiSettings extends State<ApiSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: TDNavBar(
          title: tr(LocaleKeys.settingPageApiSettingApiManger),
        ),
      ),
      body: Column(
        children: [
          // API 列表
          ApiList(),
        ],
      ),
      // 内容居中
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // 添加按钮
      floatingActionButton: TDFab(
        theme: TDFabTheme.light,
        text: tr(LocaleKeys.settingPageApiSettingAddApi),
        onClick: () {
          TDToast.showText(tr(LocaleKeys.thisFeatureIsUnderDevelopment),
              context: context);
          // Navigator.of(context).push(TDSlidePopupRoute(
          //     modalBarrierColor: TDTheme.of(context).fontGyColor2,
          //     slideTransitionFrom: SlideTransitionFrom.center,
          //     builder: (context) {
          //       return ApiInsert();
          //     }));
        },
      ),
    );
  }
}
