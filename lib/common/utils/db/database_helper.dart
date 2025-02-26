import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'init_db.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // 单例模式
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, InitDb.databaseName);

    return await openDatabase(
      path,
      version: 2, // 保持与 InitDb 中的版本控制一致
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 执行所有初始化表创建
    await db.execute(InitDb.createAIApiTable);
    // 后续增加表的添加位置
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    final queries = InitDb.upgradeQueries(oldVersion, newVersion);
    for (final query in queries) {
      await db.execute(query);
    }
  }

  // 通用插入方法
  Future<int?> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await database;
      return await db.insert(
        '$DB_TABLE_PREFIX$table',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('添加异常: $e');
      return null;
    }
  }

  // 通用查询方法
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    try {
      final db = await database;
      return await db.query(
        '$DB_TABLE_PREFIX$table',
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
      );
    } catch (e) {
      print('查询异常: $e');
      return [];
    }
  }

  // 通用更新方法
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    required String where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final db = await database;
      return await db.update(
        '$DB_TABLE_PREFIX$table',
        data,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      print('修改异常: $e');
      return -1;
    }
  }

  // 通用删除方法
  Future<int> delete(
    String table, {
    required String where,
    List<Object?>? whereArgs,
  }) async {
    try {
      final db = await database;
      return await db.delete(
        '$DB_TABLE_PREFIX$table',
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      print('删除错误: $e');
      return -1;
    }
  }

  // 事务处理
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return await db.transaction(action);
  }

  // 执行原生 SQL（用于复杂操作）
  Future<void> executeRaw(String sql) async {
    try {
      final db = await database;
      await db.execute(sql);
    } catch (e) {
      print('执行原始SQL错误: $e');
    }
  }

  // 关闭数据库连接
  Future<void> close() async {
    if (_database == null) return;
    await _database!.close();
    _database = null;
  }
}
