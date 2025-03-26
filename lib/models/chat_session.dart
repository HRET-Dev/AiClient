import 'package:drift/drift.dart';

class ChatSessions extends Table {
  // 主键ID
  IntColumn get id => integer().autoIncrement()();
  
  // 会话标题
  TextColumn get title => text()();
  
  // 会话创建时间
  DateTimeColumn get createdTime => dateTime().withDefault(Constant(DateTime.now()))();
  
  // 会话最后更新时间
  DateTimeColumn get updatedTime => dateTime().withDefault(Constant(DateTime.now()))();
  
  // 会话使用的API配置ID
  IntColumn get apiConfigId => integer().nullable()();
  
  // 会话使用的模型
  TextColumn get model => text().nullable()();
  
  // 是否已收藏
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}