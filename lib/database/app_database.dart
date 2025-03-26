// 导入AI API实体类
import 'package:ai_client/database/database_connection.dart';
import 'package:ai_client/models/ai_api.dart';
import 'package:ai_client/models/chat_message.dart';
import 'package:ai_client/models/chat_session.dart';
import 'package:ai_client/models/file_attachment.dart';
// 导入drift数据库依赖
import 'package:drift/drift.dart';

// 引入生成的数据库代码
part 'app_database.g.dart';

/// 数据库名称
const _dbName = 'ai_client.db';

// 使用DriftDatabase注解定义数据库类
@DriftDatabase(
  tables: [AiApi, ChatSessions, ChatMessages, FileAttachments]
)
class AppDatabase extends _$AppDatabase {
  // 构造函数，使用平台特定的连接方法
  AppDatabase() : super(openConnection(_dbName));

  // 重写获取数据库版本号方法
  @override
  int get schemaVersion => 1;

  //数据库迁移方法
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {},
    );
  }
}
