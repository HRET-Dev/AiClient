import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 2)
class ChatMessage extends HiveObject {
  // 主键ID
  @HiveField(0)
  late int id = 0;

  // 关联的会话ID
  @HiveField(1)
  late int sessionId;

  // 父级消息ID
  @HiveField(2)
  int? parentId;

  // 消息内容
  @HiveField(3)
  late String content;

  // 会话使用的API配置ID
  @HiveField(4)
  int? apiConfigId;

  // 会话使用的模型
  @HiveField(5)
  String? model;

  // 消息类型
  @HiveField(6)
  late MessageType type;

  // 消息角色
  @HiveField(7)
  late MessageRole role;

  // 消息创建时间
  @HiveField(8)
  late DateTime createTime = DateTime.now();

  // 如果是文件类型，存储文件路径
  @HiveField(9)
  String? filePath;

  // 消息状态（发送中、已发送、发送失败等）
  @HiveField(10)
  late MessageStatus status;
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

/// 消息类型枚举
@HiveType(typeId: 3)
enum MessageType {
  /// 文本
  @HiveField(0)
  text,

  /// 文件
  @HiveField(1)
  file,

  /// 默认
  @HiveField(2)
  system,
}

/// 消息角色枚举
@HiveType(typeId: 4)
enum MessageRole {
  /// 用户
  @HiveField(0)
  user,

  /// 助手
  @HiveField(1)
  assistant,

  /// 系统
  @HiveField(2)
  system,
}

/// 消息状态枚举
@HiveType(typeId: 5)
enum MessageStatus {
  /// 发送中
  @HiveField(0)
  send,

  /// 已发送
  @HiveField(1)
  sent,

  /// 发送失败
  @HiveField(2)
  error,
}
