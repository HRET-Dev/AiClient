// ignore_for_file: use_build_context_synchronously

import 'package:ai_client/common/utils/chat_http.dart';
import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/default_api_configs.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/repositories/ai_api_repository.dart';
import 'package:ai_client/services/ai_api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// API 信息页面
/// 添加、修改、删除一体
class ApiInfo extends StatefulWidget {
  // Api 信息实体
  final AiApiData aiApi;
  // 数据库实例
  final AppDatabase appDatabase;

  const ApiInfo({
    super.key,
    required this.aiApi,
    required this.appDatabase,
  });

  @override
  State<StatefulWidget> createState() => _ApiInfoState();
}

/// Api 信息页面的状态管理
class _ApiInfoState extends State<ApiInfo> {
  /// AiApi 服务类
  late final AiApiService _aiApiService;

  // ChatHttp 实例
  final ChatHttp _chatHttp = ChatHttp();

  /// Api 信息实体
  late AiApiData _aiApi;

  // 表单key
  final _formKey = GlobalKey<FormState>();

  // 模型列表文本控制器
  late TextEditingController _modelsController;

  @override
  void initState() {
    super.initState();
    // 初始化 AiApi 信息
    _aiApi = widget.aiApi;
    // 初始化 AiApi 服务类
    _aiApiService = AiApiService(AiApiRepository(widget.appDatabase));
    // 初始化模型列表控制器
    _modelsController = TextEditingController(text: _aiApi.models);
  }

  @override
  void dispose() {
    // 释放控制器资源
    _modelsController.dispose();
    super.dispose();
  }

  // 获取当前模型列表信息 以字符串形式展示 英文逗号分隔
  Future<String> _getModelsString() async {
    // 使用 chatHttp 获取模型列表
    final repose = await _chatHttp.getModelList(
        baseUrl: _aiApi.baseUrl,
        provider: _aiApi.provider,
        apiKey: _aiApi.apiKey);
    // 获取模型列表
    final list = repose.data["data"];
    // 解析模型列表
    final models = list?.map((e) => e['id']).join(',') ?? '';
    // 返回模型列表
    return models;
  }

  // 构建信息表单
  Widget _buildForm() {
    // 获取默认的服务类型
    final defaultServerType = DefaultApiConfigs.supportedApiProviders;

    // 构建表单
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 服务类型选择
            DropdownButtonFormField<String>(
              value: _aiApi.provider,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: tr(LocaleKeys.aiApiModelApiProvider),
              ),
              items: defaultServerType.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _aiApi = _aiApi.copyWith(provider: value);
                  });
                }
              },
            ),

            SizedBox(height: 16),

            // 服务名称
            TextFormField(
              initialValue: _aiApi.serviceName,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: tr(LocaleKeys.aiApiModelApiName),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return tr(LocaleKeys.aiApiModelApiNameValidateFailed);
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  // 更新服务名称
                  _aiApi = _aiApi.copyWith(serviceName: value);
                });
              },
            ),

            SizedBox(height: 16),

            // 基础URL
            TextFormField(
              initialValue: _aiApi.baseUrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: tr(LocaleKeys.aiApiModelApiBaseUrl),
              ),
              validator: (value) {
                // 简单URL格式验证 支持 http/https、域名/IP
                final urlPattern = RegExp(
                    r'^(http|https):\/\/([a-zA-Z0-9.-]+(:[0-9]+)?)(\/.*)?$');

                if (value == null || !urlPattern.hasMatch(value)) {
                  return tr(LocaleKeys.aiApiModelApiBaseUrlValidateFailed);
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  // 更新基础URL
                  _aiApi = _aiApi.copyWith(baseUrl: value);
                });
              },
            ),

            SizedBox(height: 16),

            // API密钥
            TextFormField(
              initialValue: _aiApi.apiKey,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: tr(LocaleKeys.aiApiModelApiKey),
              ),
              onChanged: (value) {
                setState(() {
                  _aiApi = _aiApi.copyWith(apiKey: value);
                });
              },
            ),

            SizedBox(height: 16),

            // 模型列表
            TextFormField(
              controller: _modelsController,
              maxLines: null,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: tr(LocaleKeys.aiApiModelModels),

                  // 尾部获取模型列表按钮、编辑模型列表按钮
                  suffixIcon: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () async {
                          // 判断 baseUrl 是否为空
                          if (_aiApi.baseUrl.isEmpty) {
                            // 空URL 不做任何操作
                            return;
                          }
                          // 获取模型列表
                          final models = await _getModelsString();
                          // 更新控制器的文本
                          _modelsController.text = models;
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // 判断列表是否为空
                          if (_modelsController.text.isEmpty) {
                            // 空列表 不做任何操作
                            return;
                          }

                          // 模型列表 将字符串切割为列表
                          final models = _modelsController.text.split(',');
                          // 底部抽屉展示模型列表 通过列表复选框展示选择
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              // 用于跟踪每个模型的选中状态
                              Map<String, bool> modelStates = {};
                              // 初始化所有模型的状态
                              for (var model in models) {
                                // 初始化每个模型的状态
                                modelStates[model] =
                                    _modelsController.text.contains(model);
                              }

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Column(
                                    children: [
                                      // 标题
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        child: Text(LocaleKeys.aiApiModelModels)
                                            .tr(),
                                      ),
                                      // 模型列表
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: models.length,
                                          itemBuilder: (context, index) {
                                            final model = models[index];
                                            return CheckboxListTile(
                                              title: Text(model),
                                              value: modelStates[model],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  modelStates[model] =
                                                      value ?? false;
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      // 底部按钮
                                      Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // 清除按钮
                                            ElevatedButton(
                                              onPressed: () {
                                                // 清除所有模型的选中状态
                                                setState(() {
                                                  modelStates = {
                                                    for (var model in models)
                                                      model: false
                                                  };
                                                });
                                              },
                                              child:
                                                  Text(LocaleKeys.clear).tr(),
                                            ),
                                            const SizedBox(width: 20),
                                            // 取消按钮
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child:
                                                  Text(LocaleKeys.cancel).tr(),
                                            ),
                                            const SizedBox(width: 20),
                                            // 保存按钮
                                            ElevatedButton(
                                              onPressed: () {
                                                // 获取选中的模型列表
                                                final selectedModels =
                                                    modelStates.entries
                                                        .where(
                                                            (entry) =>
                                                                entry.value)
                                                        .map((entry) =>
                                                            entry.key)
                                                        .toList();
                                                // 更新控制器文本
                                                _modelsController.text =
                                                    selectedModels.join(',');
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(LocaleKeys.save).tr(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  )),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return tr(LocaleKeys.aiApiModelModelsValidateFailed);
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(''),
      content: _buildForm(),
      actions: [
        // 删除按钮
        TextButton(
          onPressed: () async {
            // 删除 AiApiData
            final delete = await _aiApiService.deleteAiApiById(_aiApi.id);

            // 检查组件是否仍然挂载
            if (!mounted) return;

            // 关闭对话框并返回失败结果
            Navigator.of(context).pop(delete > 0 ? true : false);
          },
          child: Text(LocaleKeys.delete).tr(),
        ),
        // 取消按钮
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(LocaleKeys.cancel).tr(),
        ),
        // 保存按钮
        TextButton(
          onPressed: () async {
            // 验证表单
            if (_formKey.currentState?.validate() ?? false) {
              // 设置模型列表
              _aiApi = _aiApi.copyWith(models: _modelsController.text);
              // 将 AiApiData 转换
              final aiApiCompanion = _aiApi.toCompanion(true);

              bool result = false;
              // 判断是否有 ID
              if (_aiApi.id == 0) {
                // 插入
                result = await _aiApiService.insertAiApi(aiApiCompanion);
              } else {
                // 更新
                result = await _aiApiService.updateAiApi(aiApiCompanion);
              }

              // 检查组件是否仍然挂载
              if (!mounted) return;

              // 关闭对话框
              Navigator.of(context).pop(result);
            }
          },
          child: Text(LocaleKeys.save).tr(),
        ),
      ],
    );
  }
}
