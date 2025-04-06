/// 本地化多语言静态常量
abstract class LocaleKeys {
  //===================================================
  // 通用键 (Common Keys)
  //===================================================

  /// 聊天
  static const chat = 'Chat';

  /// 历史
  static const history = 'History';

  /// 设置
  static const settings = 'Settings';

  /// 保存
  static const save = 'save';

  /// 取消
  static const cancel = 'cancel';

  /// 清除
  static const clear = 'clear';

  /// 删除
  static const delete = 'delete';

  /// 确认
  static const confirm = 'confirm';

  /// 确认删除
  static const confirmDelete = 'confirm_delete';

  /// 确认删除提示信息
  static const confirmDeleteMessage = 'confirm_delete_message';

  /// 分享
  static const share = 'share';

  /// 已分享
  static const shared = 'shared';

  /// 导入
  static const import = 'import';

  /// 剪贴板为空
  static const clipboardEmpty = 'clipboard_empty';

  /// 该功能正在开发中
  static const thisFeatureIsUnderDevelopment =
      'this_feature_is_under_development';

  /// 请选择
  static const pleaseSelect = 'please_select';
  
  /// 复制
  static const copy = 'copy';

  /// 复制完成
  static const copySuccess = 'copy_success';
  
  //===================================================
  // 侧边栏 (Sidebar)
  //===================================================
  
  /// 侧边栏 - 显示侧边栏
  static const sidebarShow = 'sidebar.show';
  
  /// 侧边栏 - 隐藏侧边栏
  static const sidebarHide = 'sidebar.hide';
  
  /// 侧边栏 - 应用名称
  static const sidebarAppName = 'sidebar.app_name';

  /// 侧边栏 - 所有对话列表
  static const sidebarAllChats ='sidebar.all_chats';

  //===================================================
  // 聊天页面 (Chat Page)
  //===================================================

  /// 聊天页 - 新对话按钮提示值
  static const chatPageNewChat = 'chat_page.new_chat';

  /// 聊天页 - 聊天回复等待提示值
  static const chatPageThinking = 'chat_page.thinking';

  /// 聊天页 - 底部输入框提示值
  static const chatPageInputHintText = 'chat_page.input_hintText';

  //===================================================
  // 设置页面 (Settings Page)
  //===================================================

  //---------------------------------------------------
  // API 设置 (API Settings)
  //---------------------------------------------------

  /// 设置页 - API管理按钮提示值
  static const settingPageApiSettingApiManger =
      'settings_page.api_setting.api_manager';

  /// 设置页 - 添加API按钮提示值
  static const addApi = 'settings_page.api_setting.add_api';

  /// 设置页 - 编辑API按钮提示值
  static const editApi = 'settings_page.api_setting.edit_api';

  /// 设置页 - 删除API按钮提示值
  static const settingPageApiSettingDeleteApi =
      'settings_page.api_setting.delete_api';

  /// 设置页 - 添加API成功提示信息
  static const settingPageApiSettingAddSuccess =
      'settings_page.api_setting.add_success';

  /// 设置页 - 添加API失败提示信息
  static const settingPageApiSettingAddFailed =
      'settings_page.api_setting.add_failed';

  /// API配置已复制到剪贴板
  static const apiConfigCopiedToClipboard =
      'settings_page.api_setting.api_config_copied_to_clipboard';

  /// 无效的API配置字符串
  static const invalidApiConfigString =
      'settings_page.api_setting.invalid_api_config_string';

  /// 解密API配置失败
  static const failedToDecryptApiConfig =
      'settings_page.api_setting.failed_to_decrypt_api_config';

  /// API配置导入成功
  static const apiConfigImported =
      'settings_page.api_setting.api_config_imported';

  //---------------------------------------------------
  // 语言设置 (Language Settings)
  //---------------------------------------------------

  /// 设置页 - 语言按钮提示值
  static const settingPageLanguageSettingLanguageButtonText =
      'settings_page.language_setting.language_button_text';

  /// 设置页 - 选择语言按钮提示值
  static const settingPageLanguageSettingSelectLanguage =
      'settings_page.language_setting.select_language';

  /// 设置页 - 语言信息列表
  static const settingPageLanguageSettingLanguageList =
      'settings_page.language_setting.language_list';

  //===================================================
  // API 模型 (AI API Model)
  //===================================================

  /// AI API 模型
  static const aiApiModel = 'ai_api_model';

  /// API 配置
  static const aiApiModelConfig = '$aiApiModel.config';

  /// API 名称
  static const aiApiModelApiName = '$aiApiModel.api_name';

  /// API 名称校验失败 提示信息
  static const aiApiModelApiNameValidateFailed =
      '$aiApiModel.api_name_validate_failed';

  /// API 服务商
  static const aiApiModelApiProvider = '$aiApiModel.api_provider';

  /// API 服务类型
  static const aiApiModelApiType = '$aiApiModel.api_type';

  /// API 地址
  static const aiApiModelApiBaseUrl = '$aiApiModel.api_base_url';

  /// API 地址校验失败 提示信息
  static const aiApiModelApiBaseUrlValidateFailed =
      '$aiApiModel.api_base_url_validate_failed';

  /// API 密钥
  static const aiApiModelApiKey = '$aiApiModel.api_key';

  /// 模型列表
  static const aiApiModelModels = '$aiApiModel.models';

  /// 模型列表校验失败 提示信息
  static const aiApiModelModelsValidateFailed =
      '$aiApiModel.models_validate_failed';
}
