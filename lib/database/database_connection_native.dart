import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:logger/logger.dart';

// 原生平台的数据库连接实现
QueryExecutor createDriftDatabase(String dbName) {
  return LazyDatabase(() async {
    // 根据不同平台获取适合存放数据库的目录路径
    final Directory path;
    if (Platform.isAndroid) {
      path = await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS || Platform.isMacOS) {
      path = await getApplicationDocumentsDirectory();
    } else if (Platform.isWindows || Platform.isLinux) {
      path = await getApplicationSupportDirectory();
    } else {
      // 其他平台的默认处理
      path = await getApplicationSupportDirectory();
    }

    // 数据库文件
    final dbFile = p.join(path.path, 'databases', dbName);

    Logger().d(dbFile);
    return NativeDatabase(File(dbFile));
  });
}