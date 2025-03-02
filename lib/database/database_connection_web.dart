import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

// Web 平台的数据库连接实现
QueryExecutor createDriftDatabase(String dbName) {
  /// web端 使用 wasm 方式打开数据库
  return driftDatabase(
    name: dbName,
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
    ),
  );
}
