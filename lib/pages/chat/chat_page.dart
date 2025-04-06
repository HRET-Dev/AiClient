import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/pages/chat/chat_provider.dart';
import 'package:ai_client/pages/chat/input.dart';
import 'package:ai_client/pages/chat/message_list.dart';
import 'package:ai_client/pages/settings/apis/api_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 聊天页面，同时集成了 HTTP 请求和 SQLite 加载 API 配置信息
class ChatPage extends StatefulWidget {
  // 会话ID
  final int? sessionId;

  // 添加构造函数，接收 key 会话ID 参数
  const ChatPage({super.key, this.sessionId});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  // 聊天提供者
  late ChatProvider _chatProvider;

  @override
  void initState() {
    super.initState();
    // 初始化聊天提供者
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    // 初始化数据
    _initData();
  }

  // 初始化数据
  Future<void> _initData() async {
    // 判断是否传递了会话ID
    if (widget.sessionId != null && widget.sessionId! > 0) {
      // 根据会话ID查询聊天信息
      await _chatProvider.loadChatMessages(widget.sessionId!,
          chatSession: null);
    } else if (_chatProvider.chatSessionId > 0) {
      // 根据会话ID查询聊天信息
      await _chatProvider.loadChatMessages(_chatProvider.chatSessionId,
          chatSession: null);
    }
  }

  /// 显示通用提示弹窗
  void _showAlertDialog(String title, String content) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(tr(LocaleKeys.confirm)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// 聊天页信息设置弹窗
  void _showSettingsDialog() async {
    // 重新加载API配置并等待完成
    await _chatProvider.loadApiConfig();

    // 如果组件已卸载，则不继续执行
    if (!mounted) return;

    // 如果API配置为空，提示用户
    if (_chatProvider.apiConfigs.isEmpty) {
      _showAlertDialog('提示', '无可用 API 配置信息');
      return;
    }

    // 判断当前API是否为空
    if (_chatProvider.currentApi == null) {
      // 如果当前API为空，设置为第一个API
      _chatProvider.currentApi = _chatProvider.apiConfigs[0];
    } else {
      // 如果选择了则比对是否当前选择的API信息已经发生变化
      final currentApiIndex = _chatProvider.apiConfigs
          .indexWhere((api) => api.id == _chatProvider.currentApi!.id);
      if (currentApiIndex == -1) {
        // 如果当前选择的API不在配置列表中，重置为第一个API
        _chatProvider.currentApi = _chatProvider.apiConfigs[0];
      } else {
        // 更新当前API的信息
        _chatProvider.currentApi = _chatProvider.apiConfigs[currentApiIndex];
      }
    }

    // 初始化模型列表
    List<String> currentModels = _chatProvider.currentApi!.models.split(',');

    // 初始化当前模型（如果未设置或不在当前模型列表中）
    if (_chatProvider.currentModel.isEmpty ||
        !currentModels.contains(_chatProvider.currentModel)) {
      _chatProvider.currentModel =
          currentModels.isNotEmpty ? currentModels[0] : "";
    }

    // 创建临时变量用于对话框中的选择
    AiApiData tempSelectedApi = _chatProvider.currentApi!;
    String tempSelectedModel = _chatProvider.currentModel;
    bool tempUseStream = _chatProvider.useStream;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          // 根据选择的API更新模型列表
          List<String> modelOptions = tempSelectedApi.models.split(',');

          // 确保选择的模型在当前API的模型列表中
          if (!modelOptions.contains(tempSelectedModel) &&
              modelOptions.isNotEmpty) {
            tempSelectedModel = modelOptions[0];
          }

          return AlertDialog(
            title: Text(''),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // API和模型选择标题
                  Row(
                    children: [
                      Expanded(
                        child: Text(LocaleKeys.aiApiModelConfig,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center)
                            .tr(),
                      ),
                      Expanded(
                        child: Text(LocaleKeys.aiApiModelModels,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center)
                            .tr(),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // API和模型选择列表
                  SizedBox(
                    height: 200, // 设置一个固定高度
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // API列表（左侧）
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _chatProvider.apiConfigs.length,
                              itemBuilder: (context, index) {
                                var api = _chatProvider.apiConfigs[index];
                                return ListTile(
                                  title: Text(api.serviceName),
                                  subtitle: Text(
                                    api.baseUrl,
                                    style: TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  selected: tempSelectedApi.id == api.id,
                                  // 单击事件
                                  onTap: () {
                                    setState(() {
                                      tempSelectedApi = api;
                                      // 更新模型列表并选择第一个模型
                                      List<String> newModels =
                                          api.models.split(',');
                                      tempSelectedModel = newModels.isNotEmpty
                                          ? newModels[0]
                                          : "";
                                    });
                                  },
                                  // 长按事件
                                  onLongPress: () async {
                                    // 长按时 通过弹窗打开 API 详情页面
                                    final result = await showDialog(
                                      context: context,
                                      builder: (context) => ApiInfo(
                                        aiApi: api,
                                        appDatabase: _chatProvider.appDatabase,
                                      ),
                                    );

                                    // 如果组件已卸载，则不继续执行
                                    if (!mounted) return;

                                    // 判断返回结果
                                    if (result == true) {
                                      // 根据当前选择的API信息查询新的API信息
                                      final newApi = await _chatProvider
                                          .aiApiService
                                          .getAiApiById(api.id);

                                      if (newApi != null) {
                                        // 更新对应的 API 信息
                                        setState(() {
                                          // 查找当前修改的API在列表中的索引
                                          final apiIndex = _chatProvider
                                              .apiConfigs
                                              .indexWhere(
                                                  (item) => item.id == api.id);

                                          // 如果找到了，更新列表中的API信息
                                          if (apiIndex != -1) {
                                            _chatProvider.apiConfigs[apiIndex] =
                                                newApi;

                                            // 如果当前选中的就是被修改的API，也更新当前选中的API
                                            if (tempSelectedApi.id == api.id) {
                                              tempSelectedApi = newApi;
                                            }

                                            // 更新本地变量，确保UI刷新
                                            api = newApi;
                                          }
                                        });
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        // 模型列表（右侧）
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: modelOptions.length,
                              itemBuilder: (context, index) {
                                final model = modelOptions[index];
                                return ListTile(
                                  title: Text(model),
                                  selected: tempSelectedModel == model,
                                  onTap: () {
                                    setState(() {
                                      tempSelectedModel = model;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(tr(LocaleKeys.cancel)),
                onPressed: () {
                  // 关闭弹窗
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(tr(LocaleKeys.save)),
                onPressed: () {
                  // 保存选择的API和模型
                  _chatProvider.switchApi(tempSelectedApi);
                  _chatProvider.switchModel(tempSelectedModel);
                  if (tempUseStream != _chatProvider.useStream) {
                    _chatProvider.toggleStream();
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  /// 显示设置对话框 - 修改为公开方法以便外部调用
  void showSettingsDialog() async {
    _showSettingsDialog();
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度，用于判断是否为桌面端
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 600;

    return Builder(builder: (context) {
      final chatProvider = Provider.of<ChatProvider>(context);
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              // 桌面端顶部工具栏
              if (isDesktop)
                Padding(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.smart_toy_outlined,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            chatProvider.currentModel.isNotEmpty
                                ? chatProvider.currentModel
                                : 'AI Model',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.settings, size: 18),
                            onPressed: () {
                              _showSettingsDialog();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              // 消息内容区 - 桌面端时增加内边距
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: isDesktop ? 16 : 0),
                  child: MessageList(
                    messages: chatProvider.messages,
                    scrollController: chatProvider.scrollController,
                  ),
                ),
              ),
              // 输入框 - 桌面端时增加内边距和样式
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 16 : 0,
                    vertical: isDesktop ? 16 : 0),
                child: InputWidget(
                  messageController: chatProvider.inputController,
                  isWaitingResponse: chatProvider.isWaitingResponse,
                  onSendMessage: () => chatProvider
                      .sendMessage(chatProvider.inputController.text),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
