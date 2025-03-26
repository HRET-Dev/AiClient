import 'package:ai_client/database/app_database.dart';
import 'package:drift/drift.dart';

class ChatMessageRepository {
  final AppDatabase _database;

  ChatMessageRepository(this._database);

  // 获取会话的所有消息
  Future<List<ChatMessage>> getMessagesBySessionId(int sessionId) async {
    return await (_database.select(_database.chatMessages)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdTime)]))
        .get();
  }

  // 获取单条消息
  Future<ChatMessage?> getMessageById(int id) async {
    return await (_database.select(_database.chatMessages)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // 创建新消息
  Future<int> createMessage(ChatMessagesCompanion message) async {
    return await _database.into(_database.chatMessages).insert(message);
  }

  // 更新消息
  Future<bool> updateMessage(ChatMessage message) async {
    return await _database.update(_database.chatMessages).replace(message);
  }

  // 删除消息
  Future<int> deleteMessage(int id) async {
    return await (_database.delete(_database.chatMessages)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  // 删除会话的所有消息
  Future<int> deleteMessagesBySessionId(int sessionId) async {
    return await (_database.delete(_database.chatMessages)
          ..where((t) => t.sessionId.equals(sessionId)))
        .go();
  }

  // 搜索消息
  Future<List<ChatMessage>> searchMessages(String query) async {
    return await (_database.select(_database.chatMessages)
          ..where((t) => t.content.contains(query)))
        .get();
  }
}