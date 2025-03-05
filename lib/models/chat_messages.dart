import 'package:drift/drift.dart';

/// 聊天消息表定义
class ChatMessages extends Table {
  // 主键ID
  IntColumn get id => integer().autoIncrement()();
  // 消息内容
  TextColumn get content => text()();
  // 是否为用户消息
  BoolColumn get isUser => boolean()();
  // 创建时间
  DateTimeColumn get createdTime => dateTime().withDefault(currentDateAndTime)();
  // 关联的对话ID
  IntColumn get conversationId => integer().nullable()();
}

/// 聊天消息 Model
class ChatMessage {
  /// 消息内容
  String content;
  /// 是否为用户消息
  final bool isUser;
  /// 创建时间  
  final DateTime createdTime;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.createdTime,
  });
}