import 'package:ai_client/models/chat_session.dart';
import 'package:drift/drift.dart';

/// 消息类型枚举
enum MessageType {
  /// 文本
  text,

  /// 文件
  file,

  /// 默认
  system
}

/// 消息角色枚举
enum MessageRole {
  /// 用户
  user,

  /// 助手
  assistant,

  /// 系统
  system
}

/// 消息状态枚举
enum MessageStatus {
  /// 发送中
  send,

  /// 已发送
  sent,

  /// 发送失败
  error
}

/// 消息状态转换
MessageStatus convertStatus(String status) {
  switch (status) {
    case 'send':
      return MessageStatus.send;
    case 'sent':
      return MessageStatus.sent;
    default:
      return MessageStatus.error;
  }
}

class ChatMessages extends Table {
  // 主键ID
  IntColumn get id => integer().autoIncrement()();

  // 关联的会话ID
  IntColumn get sessionId => integer().references(ChatSessions, #id)();

  // 父级消息ID
  IntColumn get parentId => integer().nullable()();

  // 消息内容
  TextColumn get content => text()();
  
  // 会话使用的API配置ID
  IntColumn get apiConfigId => integer().nullable()();
  
  // 会话使用的模型
  TextColumn get model => text().nullable()();

  // 消息类型
  TextColumn get type => textEnum<MessageType>()();

  // 消息角色
  TextColumn get role => textEnum<MessageRole>()();

  // 消息创建时间
  DateTimeColumn get createdTime =>
      dateTime().withDefault(Constant(DateTime.now()))();

  // 如果是文件类型，存储文件路径
  TextColumn get filePath => text().nullable()();

  // 消息状态（发送中、已发送、发送失败等）
  TextColumn get status => textEnum<MessageStatus>()();
}
