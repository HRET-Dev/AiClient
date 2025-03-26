import 'package:ai_client/models/chat_session.dart';
import 'package:drift/drift.dart';

// 消息类型枚举
enum MessageType {
  text,
  image,
  file,
  system
}

// 消息角色枚举
enum MessageRole {
  user,
  assistant,
  system
}

class ChatMessages extends Table {
  // 主键ID
  IntColumn get id => integer().autoIncrement()();
  
  // 关联的会话ID
  IntColumn get sessionId => integer().references(ChatSessions, #id)();
  
  // 消息内容
  TextColumn get content => text()();
  
  // 消息类型
  TextColumn get type => textEnum<MessageType>()();
  
  // 消息角色
  TextColumn get role => textEnum<MessageRole>()();
  
  // 消息创建时间
  DateTimeColumn get createdTime => dateTime().withDefault(Constant(DateTime.now()))();
  
  // 如果是文件类型，存储文件路径
  TextColumn get filePath => text().nullable()();
  
  // 消息状态（发送中、已发送、发送失败等）
  TextColumn get status => text().withDefault(const Constant('sent'))();
}

/// 聊天消息 Model
class ChatMessageInfo {
  /// 消息内容
  String content;
  /// 是否为用户消息
  final bool isUser;
  /// 模型名称
  final String modelName;
  /// 创建时间  
  final DateTime createdTime;

  ChatMessageInfo({
    required this.content,
    required this.isUser,
    required this.modelName,
    required this.createdTime,
  });
}