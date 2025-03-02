import 'package:drift/drift.dart';

// 使用条件导入，根据平台自动选择正确的实现
import 'database_connection_web.dart'
    if (dart.library.io) 'database_connection_native.dart';

// 根据平台自动调用对应的实现
QueryExecutor openConnection(String dbName) {
  return createDriftDatabase(dbName);
}
