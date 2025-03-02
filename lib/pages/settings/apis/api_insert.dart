import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/repositories/ai_api__repository.dart';
import 'package:ai_client/services/ai_api_service.dart';
import 'package:drift/drift.dart' show Value;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

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

  /// AiApi 服务类
  final AiApiService _aiApiService =
      AiApiService(AiApiRepository(AppDatabase()));

  /// 验证URL格式
  String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入API地址';
    }

    // 简单URL格式验证
    final urlPattern = RegExp(
        r'^(http|https)://[a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,}(:[0-9]{1,5})?(\/.*)?$');

    if (!urlPattern.hasMatch(value)) {
      return '请输入有效的URL地址, 以http://或https://开头';
    }
    return null;
  }

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
                    // 先检查必填项是否已选择
                    if (_serviceNameController.text.isEmpty) {
                      TDToast.showIconText('请输入服务名称',
                          icon: TDIcons.error_circle, context: context);
                      return;
                    }
                    // 验证URL并处理结果
                    String? urlError = validateUrl(_baseUrlController.text);
                    if (urlError != null) {
                      TDToast.showIconText(urlError,
                          icon: TDIcons.error_circle, context: context);
                      return;
                    }
                    if (_providerController.text.isEmpty) {
                      TDToast.showIconText('请选择服务商',
                          icon: TDIcons.error_circle, context: context);
                      return;
                    }
                    if (_serviceTypeController.text.isEmpty) {
                      TDToast.showIconText('请选择服务类型',
                          icon: TDIcons.error_circle, context: context);
                      return;
                    }
                    if (_apiKeyController.text.isEmpty) {
                      TDToast.showIconText('请输入API密钥',
                          icon: TDIcons.error_circle, context: context);
                      return;
                    }

                    if (_formKey.currentState!.validate()) {
                      try {
                        final api = AiApiCompanion(
                          serviceName: Value(_serviceNameController.text),
                          provider: Value(_providerController.text),
                          serviceType: Value(_serviceTypeController.text),
                          baseUrl: Value(_baseUrlController.text),
                          apiKey: Value(_apiKeyController.text),
                          modelName: Value(_modelNameController.text),
                          modelConfig: Value(
                              _modelConfigController.text.isNotEmpty
                                  ? _modelConfigController.text
                                  : '{}'),
                          isActive:
                              Value(_isActiveController.text == '1' ? 1 : 0),
                          createdTime: Value(DateTime.now()),
                          updatedTime: Value(DateTime.now()),
                        );
                        _aiApiService.insertAiApi(api);
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
