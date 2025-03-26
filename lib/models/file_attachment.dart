import 'package:ai_client/models/chat_message.dart';
import 'package:drift/drift.dart';

class FileAttachments extends Table {
  // 主键ID
  IntColumn get id => integer().autoIncrement()();
  
  // 关联的消息ID
  IntColumn get messageId => integer().references(ChatMessages, #id)();
  
  // 文件名
  TextColumn get fileName => text()();
  
  // 文件路径
  TextColumn get filePath => text()();
  
  // 文件大小（字节）
  IntColumn get fileSize => integer()();
  
  // 文件类型
  TextColumn get fileType => text()();
  
  // 上传时间
  DateTimeColumn get uploadedAt => dateTime().withDefault(Constant(DateTime.now()))();
}