import 'package:ai_client/models/chat_session.dart';
import 'package:ai_client/services/hive_storage_service.dart';
import 'package:hive/hive.dart';

/// ChatSession 数据访问对象
class ChatSessionRepository {
  /// ChatSession 数据盒子
  final Box<ChatSession> _chatSessionBox = HiveStorageService.chatSessionBox;

  /// 构造函数
  ChatSessionRepository();

  /// 获取所有会话
  List<ChatSession> getAllSessions() {
    return _chatSessionBox.values.toList();
  }

  /// 获取收藏的会话
  List<ChatSession> getFavoriteSessions() {
    return _chatSessionBox.values.where((s) => s.isFavorite).toList();
  }

  /// 根据 ID 获取会话
  ChatSession? getSessionById(int id) {
    return _chatSessionBox.values.where((s) => s.id == id).firstOrNull;
  }

  /// 创建新会话
  /// 返回自动生成的 key 作为 id
  Future<int> insertSession(ChatSession session) async {
    final key = await _chatSessionBox.add(session);
    session.id = key;
    await session.save();
    return key;
  }

  /// 批量插入会话列表
  Future<void> insertSessions(List<ChatSession> sessions) async {
    final keys = (await _chatSessionBox.addAll(sessions)).toList();
    for (var i = 0; i < sessions.length; i++) {
      sessions[i].id = keys[i];
      await sessions[i].save();
    }
  }

  /// 更新会话
  Future<void> updateSession(ChatSession session) async {
    await session.save();
  }

  /// 删除会话
  Future<void> deleteSession(int id) async {
    await _chatSessionBox.delete(id);
  }

  /// 搜索会话（根据标题模糊匹配）
  List<ChatSession> searchSessions(String query) {
    return _chatSessionBox.values
        .where((s) => s.title.contains(query))
        .toList();
  }

  /// 切换收藏状态
  Future<bool> toggleFavorite(int id) async {
    final session = getSessionById(id);
    if (session == null) return false;
    session.isFavorite = !session.isFavorite;
    await session.save();
    return true;
  }
}
