import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/default_api_configs.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/pages/settings/apis/api_info.dart';
import 'package:ai_client/pages/settings/apis/api_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
  // 获取 AppDatabase 实例
  final AppDatabase appDatabase = AppDatabase();

  /// 添加按钮
  Widget _addButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: tr(LocaleKeys.addApi),
      onPressed: () async {
        // 从 DefaultApiConfigs 获取第一个支持的 API 提供商作为默认值
        final defaultProvider =
            DefaultApiConfigs.supportedApiProviders.isNotEmpty
                ? DefaultApiConfigs.supportedApiProviders.first
                : 'OpenAI'; // 提供一个后备默认值
        // 打开 AiApi 信息弹窗，创建一个新的空 AiApiData 对象
        final result = await showDialog(
          context: context,
          builder: (context) => ApiInfo(
            aiApi: AiApiData(
              id: 0,
              provider: defaultProvider,
              serviceName: '',
              baseUrl: '',
              apiKey: '',
              models: '',
              createdTime: DateTime.now(),
              isActive: true,
              updatedTime: DateTime.now(),
            ),
            appDatabase: appDatabase,
          ),
        );

        // 如果保存成功，刷新列表
        if (result == true) {
          // 通过 key 刷新 ApiList
          setState(() {});
        }
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ApiList(key: UniqueKey(), appDatabase: appDatabase),
            ),
          ],
        ),
      ),
    );
  }
}
