import 'package:ai_client/database/app_database.dart';
import 'package:drift/drift.dart';

class ChatSessionRepository {
  final AppDatabase _database;

  ChatSessionRepository(this._database);

  // 获取所有会话
  Future<List<ChatSession>> getAllSessions() async {
    return await _database.select(_database.chatSessions).get();
  }

  // 获取收藏的会话
  Future<List<ChatSession>> getFavoriteSessions() async {
    return await (_database.select(_database.chatSessions)
          ..where((t) => t.isFavorite.equals(true)))
        .get();
  }

  // 根据ID获取会话
  Future<ChatSession?> getSessionById(int id) async {
    return await (_database.select(_database.chatSessions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // 创建新会话
  Future<int> createSession(ChatSessionsCompanion session) async {
    return await _database.into(_database.chatSessions).insert(session);
  }

  // 更新会话
  Future<bool> updateSession(ChatSession session) async {
    return await _database.update(_database.chatSessions).replace(session);
  }

  // 删除会话
  Future<int> deleteSession(int id) async {
    return await (_database.delete(_database.chatSessions)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  // 搜索会话
  Future<List<ChatSession>> searchSessions(String query) async {
    return await (_database.select(_database.chatSessions)
          ..where((t) => t.title.contains(query)))
        .get();
  }

  // 切换收藏状态
  Future<bool> toggleFavorite(int id) async {
    final session = await getSessionById(id);
    if (session != null) {
      final updatedSession = session.copyWith(isFavorite: !session.isFavorite);
      return await updateSession(updatedSession);
    }
    return false;
  }
}