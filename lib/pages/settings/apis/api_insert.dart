// API 添加页面
import 'dart:convert';

import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/models/ai_api.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../../common/utils/db/ai_api_repository.dart';
import '../../../generated/default_api_configs.dart';

// API 添加
class ApiInsert extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ApiInsert();
}

// API 添加状态管理
class _ApiInsert extends State<ApiInsert> {
  /// 表单
  final _formKey = GlobalKey<FormState>();

  /// 服务名称
  final _serviceNameController = TextEditingController();

  /// 服务商
  final _providerController = TextEditingController();

  /// 服务类型
  final _serviceTypeController = TextEditingController();

  /// API 地址
  final _baseUrlController = TextEditingController();

  /// API 密钥
  final _apiKeyController = TextEditingController();

  /// 模型名称
  final _modelNameController = TextEditingController();

  /// 模型配置
  final _modelConfigController = TextEditingController();

  /// 是否启用
  final _isActiveController = TextEditingController(text: '1');

  /// AiApi 数据库操作封装
  AIApiRepository repository = AIApiRepository();

  /// 服务商选择器
  Widget buildProviderWithTitle(BuildContext context) {
    /// 支持的服务商列表
    var supportedApiProviders = DefaultApiConfigs.supportedApiProviders;

    return GestureDetector(
      onTap: () {
        TDPicker.showMultiPicker(context,
            title: tr(LocaleKeys.aiApiModelApiProvider), onConfirm: (selected) {
          setState(() {
            _providerController.text = supportedApiProviders[selected[0]];
          });
          Navigator.of(context).pop();
        }, data: [supportedApiProviders]);
      },
      child: buildSelectRow(context, _providerController.text,
          tr(LocaleKeys.aiApiModelSelectApiProvider)),
    );
  }

  /// 服务类型选择器
  Widget buildServiceTypeWithTitle(BuildContext context) {
    /// 支持的服务类型列表
    var supportedApiTypes = DefaultApiConfigs.supportedApiTypes;

    return GestureDetector(
      onTap: () {
        TDPicker.showMultiPicker(context,
            title: tr(LocaleKeys.aiApiModelApiType), onConfirm: (selected) {
          setState(() {
            _serviceTypeController.text = supportedApiTypes[selected[0]];
          });
          Navigator.of(context).pop();
        }, data: [supportedApiTypes]);
      },
      child: buildSelectRow(context, _serviceTypeController.text,
          tr(LocaleKeys.aiApiModelSelectApiType)),
    );
  }

  /// 构建选择行
  Widget buildSelectRow(BuildContext context, String value, String title) {
    // 获取屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;

    // 根据屏幕宽度动态设置字体大小
    double fontSize = screenWidth > 600 ? 16 : 14;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis, // 超出部分显示省略号
            ),
          ),
          Row(
            children: [
              Text(
                value.isEmpty ? tr(LocaleKeys.pleaseSelect) : value,
                style: TextStyle(
                  fontSize: fontSize,
                  color: value.isEmpty ? Colors.grey[400] : Colors.black,
                ),
                overflow: TextOverflow.ellipsis, // 超出部分显示省略号
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[600],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDNavBar(title: tr(LocaleKeys.settingPageApiSettingAddApi)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TDInput(
                leftInfoWidth: 100,
                controller: _serviceNameController,
                leftLabel: tr(LocaleKeys.aiApiModelApiName),
                hintText: tr(LocaleKeys.aiApiModelEnterApiName),
              ),
              buildProviderWithTitle(context), // 服务商选择器
              SizedBox(height: 10),
              buildServiceTypeWithTitle(context), // 服务类型选择器
              SizedBox(height: 10),
              TDInput(
                leftInfoWidth: 100,
                controller: _baseUrlController,
                leftLabel: tr(LocaleKeys.aiApiModelApiBaseUrl),
                hintText: tr(LocaleKeys.aiApiModelEnterApiBaseUrl),
              ),
              SizedBox(height: 10),
              TDInput(
                leftInfoWidth: 100,
                controller: _apiKeyController,
                leftLabel: tr(LocaleKeys.aiApiModelApiKey),
                hintText: tr(LocaleKeys.aiApiModelEnterApiKey),
              ),
              SizedBox(height: 10),
              TDInput(
                leftInfoWidth: 100,
                controller: _modelNameController,
                leftLabel: tr(LocaleKeys.aiApiModelModelName),
                hintText: tr(LocaleKeys.aiApiModelEnterModelName),
              ),
              SizedBox(height: 10),
              TDInput(
                leftInfoWidth: 100,
                controller: _modelConfigController,
                leftLabel: tr(LocaleKeys.aiApiModelModelConfig),
                hintText: tr(LocaleKeys.aiApiModelModelConfig),
                additionInfo: tr(LocaleKeys.aiApiModelEnterModelConfig),
              ),
              SizedBox(height: 20),
              Center(
                child: TDButton(
                  type: TDButtonType.fill,
                  shape: TDButtonShape.rectangle,
                  theme: TDButtonTheme.light,
                  text: tr(LocaleKeys.settingPageApiSettingAddApi),
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final api = AIApi(
                          serviceName: _serviceNameController.text,
                          provider: _providerController.text,
                          serviceType: _serviceTypeController.text,
                          baseUrl: _baseUrlController.text,
                          apiKey: _apiKeyController.text,
                          modelName: _modelNameController.text,
                          modelConfig: _modelConfigController.text.isNotEmpty
                              ? jsonDecode(_modelConfigController.text)
                              : {},
                          isActive: _isActiveController.text == '1',
                        );
                        await repository.addAIApi(api);
                        TDToast.showSuccess(
                            tr(LocaleKeys.settingPageApiSettingAddSuccess),
                            context: context);
                        Navigator.pop(context);
                      } catch (e) {
                        showGeneralDialog(
                          context: context,
                          pageBuilder: (BuildContext buildContext,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return TDConfirmDialog(
                              content:
                                  '${tr(LocaleKeys.settingPageApiSettingAddFailed)}: $e',
                              contentMaxHeight: 300,
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
