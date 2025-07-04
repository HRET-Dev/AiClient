// ignore_for_file: use_build_context_synchronously

import 'package:ai_client/common/utils/chat_http.dart';
import 'package:ai_client/generated/default_api_configs.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/models/ai_api.dart';
import 'package:ai_client/services/ai_api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// API 信息页面
/// 添加、修改、删除一体
class ApiInfo extends StatefulWidget {
  // Api 信息实体
  final AiApi aiApi;

  const ApiInfo({super.key, required this.aiApi});

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
  late AiApi _aiApi;

  // 表单key
  final _formKey = GlobalKey<FormState>();

  // 文本控制器
  late TextEditingController _serviceNameController;
  late TextEditingController _baseUrlController;
  late TextEditingController _apiKeyController;
  late TextEditingController _modelsController;

  // 状态标志
  bool _isShared = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // 初始化 AiApi 信息
    _aiApi = widget.aiApi;
    // 初始化 AiApi 服务类
    _aiApiService = AiApiService();

    // 初始化所有控制器
    _serviceNameController = TextEditingController(text: _aiApi.serviceName);
    _baseUrlController = TextEditingController(text: _aiApi.baseUrl);
    _apiKeyController = TextEditingController(text: _aiApi.apiKey);
    _modelsController = TextEditingController(text: _aiApi.models);
  }

  @override
  void dispose() {
    // 释放所有控制器资源
    _serviceNameController.dispose();
    _baseUrlController.dispose();
    _apiKeyController.dispose();
    _modelsController.dispose();
    super.dispose();
  }

  // 显示提示消息
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 获取当前模型列表信息 以字符串形式展示 英文逗号分隔
  Future<String> _getModelsString() async {
    try {
      // 使用 chatHttp 获取模型列表
      final response = await _chatHttp.getModelList(
        baseUrl: _aiApi.baseUrl,
        provider: _aiApi.provider,
        apiKey: _aiApi.apiKey,
      );

      // 获取模型列表
      final list = response.data["data"];
      // 解析模型列表
      return list?.map((e) => e['id']).join(',') ?? '';
    } catch (e) {
      _showSnackBar("获取模型列表失败: $e");
      return '';
    }
  }

  // 分享API配置
  Future<void> _shareApiConfig() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      // 更新模型列表
      _aiApi.models = _modelsController.text;

      // 生成加密的配置字符串
      final configString = DefaultApiConfigs.encryptApiConfig(_aiApi);

      // 复制到剪贴板
      await Clipboard.setData(ClipboardData(text: configString));

      // 更新状态
      setState(() {
        _isShared = true;
        _isProcessing = false;
      });

      // 显示提示
      _showSnackBar("配置信息已复制");

      // 3秒后重置状态
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _isShared = false);
        }
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      _showSnackBar("复制配置失败: $e");
    }
  }

  // 导入API配置
  Future<void> _importApiConfig() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      // 从剪贴板获取数据
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData == null ||
          clipboardData.text == null ||
          clipboardData.text!.isEmpty) {
        _showSnackBar("剪贴板为空");
        setState(() => _isProcessing = false);
        return;
      }

      final configString = clipboardData.text!.trim();

      // 验证配置字符串
      if (!DefaultApiConfigs.isValidApiConfigString(configString)) {
        _showSnackBar("无效的配置信息格式");
        setState(() => _isProcessing = false);
        return;
      }

      // 解密配置
      final apiConfig = DefaultApiConfigs.decryptApiConfig(configString);
      if (apiConfig == null) {
        _showSnackBar("配置信息解析失败");
        setState(() => _isProcessing = false);
        return;
      }

      // 更新当前表单
      setState(() {
        _aiApi
          ..serviceName = apiConfig.serviceName
          ..provider = apiConfig.provider
          ..baseUrl = apiConfig.baseUrl
          ..apiKey = apiConfig.apiKey
          ..models = apiConfig.models;

        // 更新所有控制器文本
        _serviceNameController.text = apiConfig.serviceName;
        _baseUrlController.text = apiConfig.baseUrl;
        _apiKeyController.text = apiConfig.apiKey;
        _modelsController.text = apiConfig.models;

        _isProcessing = false;
      });

      // 显示提示
      _showSnackBar("配置信息导入成功");
    } catch (e) {
      setState(() => _isProcessing = false);
      _showSnackBar("导入配置失败: $e");
    }
  }

  // 构建信息表单
  Widget _buildForm() {
    // 获取默认的服务类型
    final defaultServerType = DefaultApiConfigs.supportedApiProviders;

    // 构建表单
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16),
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
                border: const OutlineInputBorder(),
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
                    _aiApi.provider = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            // 服务名称
            TextFormField(
              controller: _serviceNameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
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
                  _aiApi.serviceName = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // 基础URL
            TextFormField(
              controller: _baseUrlController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
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
                  _aiApi.baseUrl = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // API密钥
            TextFormField(
              controller: _apiKeyController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: tr(LocaleKeys.aiApiModelApiKey),
              ),
              onChanged: (value) {
                setState(() {
                  _aiApi.apiKey = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // 模型列表
            TextFormField(
              controller: _modelsController,
              maxLines: null,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: tr(LocaleKeys.aiApiModelModels),
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 刷新模型列表按钮
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: '获取模型列表',
                      onPressed: () async {
                        // 判断 baseUrl 是否为空
                        if (_aiApi.baseUrl.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("请先填写API基础URL"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        // 获取模型列表
                        final models = await _getModelsString();

                        // 更新控制器的文本
                        setState(() {
                          _modelsController.text = models;
                        });
                      },
                    ),
                    // 编辑模型列表按钮
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: '编辑模型列表',
                      onPressed: () {
                        // 判断列表是否为空
                        if (_modelsController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("模型列表为空"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        // 模型列表 将字符串切割为列表
                        final models = _modelsController.text.split(',');

                        // 底部抽屉展示模型列表
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            // 用于跟踪每个模型的选中状态
                            Map<String, bool> modelStates = {};
                            // 初始化所有模型的状态
                            for (var model in models) {
                              modelStates[model] =
                                  _modelsController.text.contains(model);
                            }

                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    // 标题
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
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
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // 清除按钮
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                modelStates = {
                                                  for (var model in models)
                                                    model: false
                                                };
                                              });
                                            },
                                            child: Text(LocaleKeys.clear).tr(),
                                          ),
                                          const SizedBox(width: 20),
                                          // 取消按钮
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(LocaleKeys.cancel).tr(),
                                          ),
                                          const SizedBox(width: 20),
                                          // 保存按钮
                                          ElevatedButton(
                                            onPressed: () {
                                              // 获取选中的模型列表
                                              final selectedModels = modelStates
                                                  .entries
                                                  .where((entry) => entry.value)
                                                  .map((entry) => entry.key)
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
                ),
              ),
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
      title: Text(_aiApi.id == 0 ? LocaleKeys.addApi : LocaleKeys.editApi).tr(),
      content: _buildForm(),
      actions: [
        // 左侧按钮组
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 分享按钮
            Tooltip(
              message: tr(LocaleKeys.share),
              child: IconButton(
                icon: Icon(
                  _isShared ? Icons.check : Icons.share,
                  size: 20,
                  color: _isShared ? Colors.green : null,
                ),
                onPressed: _shareApiConfig,
              ),
            ),
            // 导入按钮
            Tooltip(
              message: tr(LocaleKeys.import),
              child: IconButton(
                icon: const Icon(
                  Icons.paste,
                  size: 20,
                ),
                onPressed: _importApiConfig,
              ),
            ),
            // 删除按钮 (仅当编辑现有API时显示)
            if (_aiApi.id != 0)
              Tooltip(
                message: tr(LocaleKeys.delete),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 20,
                  ),
                  onPressed: () async {
                    // 删除确认对话框
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(LocaleKeys.confirmDelete).tr(),
                        content: Text(LocaleKeys.confirmDeleteMessage).tr(),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(LocaleKeys.cancel).tr(),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(LocaleKeys.confirm).tr(),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) return;

                    // 删除 AiApiData
                    final delete =
                        await _aiApiService.deleteAiApiById(_aiApi.id);

                    // 检查组件是否仍然挂载
                    if (!mounted) return;

                    // 关闭对话框并返回结果
                    Navigator.of(context).pop(delete);
                  },
                ),
              ),
          ],
        ),
        // 右侧按钮组
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 取消按钮
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(LocaleKeys.cancel).tr(),
            ),
            const SizedBox(width: 8),
            // 保存按钮
            ElevatedButton(
              onPressed: () async {
                // 验证表单
                if (_formKey.currentState?.validate() ?? false) {
                  // 设置模型列表
                  _aiApi.models = _modelsController.text;

                  bool result = false;
                  // 判断是否有 ID
                  if (_aiApi.id == 0) {
                    // 插入
                    result = await _aiApiService.insertAiApi(_aiApi);
                  } else {
                    // 更新
                    result = await _aiApiService.updateAiApi(_aiApi);
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
        ),
      ],
    );
  }
}
