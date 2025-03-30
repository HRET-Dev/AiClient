import 'package:ai_client/common/utils/chat_http.dart';
import 'package:ai_client/database/app_database.dart';
import 'package:ai_client/generated/locale_keys.dart';
import 'package:ai_client/models/chat_message.dart';
import 'package:ai_client/pages/chat/input.dart';
import 'package:ai_client/pages/chat/message_list.dart';
import 'package:ai_client/pages/settings/apis/api_info.dart';
import 'package:ai_client/repositories/ai_api_repository.dart';
import 'package:ai_client/repositories/chat_message_repository.dart';
import 'package:ai_client/repositories/chat_session_repository.dart';
import 'package:ai_client/services/ai_api_service.dart';
import 'package:ai_client/services/chat_message_service.dart';
import 'package:ai_client/services/chat_session_service.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
  // 消息列表
  List<ChatMessage> _messages = [];

  // 消息输入框控制器
  TextEditingController _messageController = TextEditingController();

  // 滚动控制器
  final ScrollController _scrollController = ScrollController();

  // 使用 ChatHttp 调用 OpenAI 接口
  final ChatHttp _chatHttp = ChatHttp();

  // 数据源
  late final AppDatabase _appDatabase;

  /// AiApi 服务类
  late final AiApiService _aiApiService;

  /// 聊天会话 服务类
  late final ChatSessionService _chatSessionService;

  /// 聊天信息 服务类
  late final ChatMessageService _chatMessageService;

  // 聊天会话 ID
  int _chatSessionId = 0;

  // 加载到的 API 配置列表
  late List<AiApiData> _apiConfig;

  // 当前正在使用的 API 配置
  AiApiData? _currentApi;

  // 当前模型列表
  List<String> _models = [];

  // 当前选择的 模型
  String _currentModel = "";

  // 是否正在等待回复
  bool _isWaitingResponse = false;

  // 是否使用流式请求
  bool _useStream = false;

  @override
  void initState() {
    super.initState();
    // 初始化数据源
    _appDatabase = AppDatabase();
    // 初始化 AiApi 服务类
    _aiApiService = AiApiService(AiApiRepository(_appDatabase));
    // 初始化聊天会话 服务类
    _chatSessionService = ChatSessionService(
        ChatSessionRepository(_appDatabase),
        ChatMessageRepository(_appDatabase));
    // 初始化聊天信息 服务类
    _chatMessageService = ChatMessageService(
        ChatMessageRepository(_appDatabase),
        ChatSessionRepository(_appDatabase));
    // 初始化 API 配置
    _loadApiConfig();

    // 判断是否传递了会话ID
    if (widget.sessionId != null && widget.sessionId! > 0) {
      // 根据会话ID查询聊天信息
      _loadChatMessages(widget.sessionId!);
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

  // 从 SQLite 数据库中加载 API 配置信息，优先取第一条记录
  Future<void> _loadApiConfig() async {
    final apis = await _aiApiService.initDefaultAiApiConfig();
    if (apis.isNotEmpty) {
      setState(() {
        // 设置 API 配置列表
        _apiConfig = apis;
      });
    } else {
      _showAlertDialog('提示', '未找到 API 配置信息');
    }
  }

  /// 根据会话ID 加载对应的聊天记录列表
  void _loadChatMessages(int sessionId) async {
    // 根据会话ID查询聊天信息
    final messages =
        await _chatMessageService.getMessagesBySessionId(sessionId);
    // 判断是否有数据
    if (messages.isNotEmpty) {
      setState(() {
        // 设置聊天会话ID
        _chatSessionId = sessionId;
        // 设置消息列表
        _messages = messages;
      });
    }
  }

  /// 加载指定会话的聊天记录列表
  void loadSession(int sessionId) {
    // 清空当前会话
    clearChat();

    // 设置新的会话ID
    setState(() {
      _chatSessionId = sessionId;
    });

    // 加载历史聊天记录
    _loadChatMessages(sessionId);
  }

  /// 聊天页信息设置弹窗
  void _showSettingsDialog() async {
    // 重新加载API配置并等待完成
    await _loadApiConfig();

    // 如果组件已卸载，则不继续执行
    if (!mounted) return;

    // 如果API配置为空，提示用户
    if (_apiConfig.isEmpty) {
      _showAlertDialog('提示', '无可用 API 配置信息');
      return;
    }

    // 判断当前API是否为空
    if (_currentApi == null) {
      // 如果当前API为空，设置为第一个API
      _currentApi = _apiConfig[0];
    } else {
      // 如果选择了则比对是否当前选择的API信息已经发生变化
      final currentApiIndex =
          _apiConfig.indexWhere((api) => api.id == _currentApi!.id);
      if (currentApiIndex == -1) {
        // 如果当前选择的API不在配置列表中，重置为第一个API
        _currentApi = _apiConfig[0];
      } else {
        // 更新当前API的信息
        _currentApi = _apiConfig[currentApiIndex];
      }
    }

    // 初始化模型列表
    List<String> currentModels = _currentApi!.models.split(',');

    // 初始化当前模型（如果未设置或不在当前模型列表中）
    if (_currentModel.isEmpty || !currentModels.contains(_currentModel)) {
      _currentModel = currentModels.isNotEmpty ? currentModels[0] : "";
    }

    // 创建临时变量用于对话框中的选择
    AiApiData tempSelectedApi = _currentApi!;
    String tempSelectedModel = _currentModel;
    bool tempUseStream = _useStream;

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
                              itemCount: _apiConfig.length,
                              itemBuilder: (context, index) {
                                var api = _apiConfig[index];
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
                                        appDatabase: _appDatabase,
                                      ),
                                    );

                                    // 如果组件已卸载，则不继续执行
                                    if (!mounted) return;

                                    // 判断返回结果
                                    if (result == true) {
                                      // 根据当前选择的API信息查询新的API信息
                                      final newApi = await _aiApiService
                                          .getAiApiById(api.id);

                                      if (newApi != null) {
                                        // 更新对应的 API 信息
                                        setState(() {
                                          // 查找当前修改的API在列表中的索引
                                          final apiIndex =
                                              _apiConfig.indexWhere(
                                                  (item) => item.id == api.id);

                                          // 如果找到了，更新列表中的API信息
                                          if (apiIndex != -1) {
                                            _apiConfig[apiIndex] = newApi;

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
                  this.setState(() {
                    _currentApi = tempSelectedApi;
                    _currentModel = tempSelectedModel;
                    _useStream = tempUseStream;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  /// 滚动到最底部
  void _scrollToBottom() {
    // 添加短暂延迟，确保布局已更新
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 发送消息
  Future<void> _sendMessage() async {
    // 判断输入框是否为空 或者 正在等待回复
    if (_isWaitingResponse || _messageController.text.isEmpty) return;

    // 判断是否有可用 API 配置信息
    if (_apiConfig.isEmpty) {
      _showAlertDialog('提示', '无可用 API 配置信息');
      return;
    }

    // 当前没有 API 配置信息时，默认使用第一条
    _currentApi ??= _apiConfig[0];

    // 加载模型列表
    _models = _currentApi!.models.split(',');

    // 当前没有模型时，默认使用第一条
    if (_currentModel.isEmpty) {
      _currentModel = _models.isNotEmpty ? _models[0] : "";
    }

    // 存储一个新的消息列表 防止历史消息被覆盖
    List<ChatMessage> newMessages = List.from(_messages);

    final userMessage = _messageController.text;
    setState(() {
      _messages.add(ChatMessage(
          id: 0,
          sessionId: _chatSessionId,
          content: userMessage,
          model: _currentModel,
          type: MessageType.system,
          role: MessageRole.user,
          createdTime: DateTime.now(),
          status: MessageStatus.sent));
      _messageController.clear();
      _isWaitingResponse = true; // 设置等待状态
    });
    // 滚动到最底部
    _scrollToBottom();

    // 默认加载中
    var aiMessage = ChatMessage(
        id: 0,
        sessionId: _chatSessionId,
        content: tr(LocaleKeys.chatPageThinking),
        model: _currentModel,
        type: MessageType.system,
        role: MessageRole.assistant,
        createdTime: DateTime.now(),
        status: MessageStatus.send);
    setState(() {
      _messages.add(aiMessage);
    });

    // 记录AI消息在消息列表中的索引
    final aiMessageIndex = _messages.length - 1;

    try {
      if (_useStream) {
        // 流式请求处理
        final responseStream = await _chatHttp.sendStreamChatRequest(
            api: _currentApi!,
            model: _currentModel,
            message: userMessage,
            historys: newMessages);

        // 用于累积AI回复的内容
        String accumulatedContent = "";

        // 处理流
        responseStream.listen((content) {
          // 累积内容
          accumulatedContent += content;

          // 更新消息内容
          setState(() {
            // 更新aiMessage变量
            aiMessage = aiMessage.copyWith(
                content: accumulatedContent, status: MessageStatus.sent);

            // 直接使用索引更新_messages列表
            if (aiMessageIndex < _messages.length) {
              _messages[aiMessageIndex] = aiMessage;
            }
          });
          // 滚动到最底部
          _scrollToBottom();
        }, onDone: () {
          // 流结束时的处理
          setState(() {
            _isWaitingResponse = false; // 清除等待状态
          });
          // 滚动到最底部
          _scrollToBottom();
        }, onError: (error) {
          // 错误处理
          setState(() {
            aiMessage = aiMessage.copyWith(
                content: "发生错误: $error", status: MessageStatus.error);

            // 直接使用索引更新_messages列表
            if (aiMessageIndex < _messages.length) {
              _messages[aiMessageIndex] = aiMessage;
            }

            _isWaitingResponse = false; // 清除等待状态
          });
          // 滚动到最底部
          _scrollToBottom();
        });
      } else {
        // 非流式请求处理
        final response = await _chatHttp.sendChatRequest(
            api: _currentApi!,
            model: _currentModel,
            message: userMessage,
            historys: newMessages);

        // 从响应中提取内容
        final content =
            response.data['choices'][0]['message']['content'] as String;

        // 更新消息内容
        setState(() {
          aiMessage =
              aiMessage.copyWith(content: content, status: MessageStatus.sent);

          // 直接使用索引更新_messages列表
          if (aiMessageIndex < _messages.length) {
            _messages[aiMessageIndex] = aiMessage;
          }

          _isWaitingResponse = false; // 清除等待状态
        });
        // 滚动到最底部
        _scrollToBottom();
      }
    } catch (e) {
      // 控制台打印错误信息
      print('请求出错: $e');
      // 出错时，显示错误信息
      String errorMessage = '请求出错';
      if (e is DioException && e.response != null) {
        errorMessage =
            '请求出错: 状态码 ${e.response!.statusCode} - ${e.response!.data}';
      } else {
        errorMessage = '请求出错: $e';
      }
      setState(() {
        // 直接使用之前保存的索引更新消息
        if (aiMessageIndex < _messages.length) {
          _messages[aiMessageIndex] = ChatMessage(
              id: 0,
              sessionId: _chatSessionId,
              content: errorMessage,
              model: _currentModel,
              type: MessageType.system,
              role: MessageRole.assistant,
              createdTime: DateTime.now(),
              status: MessageStatus.error);
        }
        _isWaitingResponse = false; // 清除等待状态
      });
    }

    // 保存聊天记录
    saveChat();
  }

  /// 保存聊天记录
  void saveChat() async {
    // 如果没有消息，则不保存
    if (_messages.isEmpty) return;

    // 确保组件已挂载
    if (mounted) {
      try {
        // 判断是否是已有会话的聊天记录
        if (_chatSessionId != 0) {
          // 更新会话信息
          await _chatSessionService.updateSession(_chatSessionId,
              apiConfigId: _currentApi?.id, model: _currentModel);
        } else {
          // 创建会话信息 会话标题取第一条消息的前15个字（如果消息长度不足15个字则取全部）
          final title = _messages.isNotEmpty
              ? _messages[0].content.toString().length > 15
                  ? _messages[0].content.toString().substring(0, 15)
                  : _messages[0].content.toString()
              : "新会话";

          // 保存会话信息并获取会话ID
          int sessionId = await _chatSessionService.createSession(title,
              apiConfigId: _currentApi!.id, model: _currentModel);

          setState(() {
            // 更新会话ID
            _chatSessionId = sessionId;
          });
        }

        // 创建聊天信息
        for (int i = 0; i < _messages.length; i++) {
          // 获取消息信息
          var message = _messages[i];

          // 检查消息是否已经保存过
          if (message.id != 0) continue;

          // 创建文本类型的消息
          int messageId = await _chatMessageService.createTextMessage(
              sessionId: _chatSessionId,
              content: message.content.toString(),
              apiConfigId: _currentApi!.id,
              model: _currentModel,
              role: message.role,
              status: message.status);

          // 更新消息的ID
          setState(() {
            // 直接更新列表中的消息对象
            _messages[i] = message.copyWith(id: messageId);
          });
        }
      } catch (e) {
        print('保存聊天记录失败: $e');
      }
    }
  }

  /// 清除聊天记录
  void clearChat() {
    // 确保只有在组件已挂载时才调用 setState
    if (mounted) {
      setState(() {
        // 清空消息列表
        _messages.clear();
        // 清空会话ID
        _chatSessionId = 0;
      });
    } else {
      // 如果组件未挂载，直接清空消息列表
      _messages.clear();
      // 清空会话ID
      _chatSessionId = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕宽度，用于判断是否为桌面端
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // 顶部工具栏
            if (!isDesktop)
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 左侧设置按钮
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.settings, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () {
                          _showSettingsDialog();
                        },
                      ),
                    ),
                    // 中间标题
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.smart_toy_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _currentModel.isNotEmpty ? _currentModel : 'AI Chat',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    // 右侧新对话按钮
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.add, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () {
                          clearChat();
                        },
                        tooltip: tr(LocaleKeys.chatPageNewChat),
                      ),
                    ),
                  ],
                ),
              ),
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
                          _currentModel.isNotEmpty ? _currentModel : 'AI Model',
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
                  messages: _messages,
                  scrollController: _scrollController,
                ),
              ),
            ),
            // 输入框 - 桌面端时增加内边距和样式
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 16 : 0, vertical: isDesktop ? 16 : 0),
              child: InputWidget(
                messageController: _messageController,
                isWaitingResponse: _isWaitingResponse,
                onSendMessage: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
