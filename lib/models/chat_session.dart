import 'package:hive/hive.dart';

part 'chat_session.g.dart';

@HiveType(typeId: 1)
class ChatSession extends HiveObject {
  // 主键ID
  @HiveField(1)
  late int id = 0;

  // 会话标题
  @HiveField(2)
  late String title;

  // 会话使用的API配置ID
  @HiveField(3)
  late int apiConfigId;

  // 会话使用的模型
  @HiveField(4)
  late String model;

  // 会话创建时间
  @HiveField(5)
  late DateTime createTime = DateTime.now();

  // 会话最后更新时间
  @HiveField(6)
  late DateTime updateTime = DateTime.now();

  // 是否已收藏
  @HiveField(7)
  late bool isFavorite = false;
}
