import 'package:ai_client/models/chat_message.dart';
import 'package:ai_client/services/hive_storage_service.dart';
import 'package:hive/hive.dart';

/// ChatMessage 数据访问对象
class ChatMessageRepository {
  /// ChatMessage 数据盒子
  final Box<ChatMessage> _chatMessageBox = HiveStorageService.chatMessageBox;

  /// 构造函数
  ChatMessageRepository();

  /// 获取所有 ChatMessage 记录
  List<ChatMessage> getAllChatMessages() {
    return _chatMessageBox.values.toList();
  }

  /// 根据会话 ID 获取消息列表
  List<ChatMessage> getMessagesBySessionId(int sessionId) {
    return _chatMessageBox.values
        .where((msg) => msg.sessionId == sessionId)
        .toList();
  }

  /// 根据 ID 获取单条消息
  ChatMessage? getMessageById(int id) {
    return _chatMessageBox.values.where((msg) => msg.id == id).firstOrNull;
  }

  /// 插入单条 ChatMessage
  /// 返回自动生成的 key 作为 id
  Future<int> insertChatMessage(ChatMessage message) async {
    final key = await _chatMessageBox.add(message);
    message.id = key;
    await message.save();
    return key;
  }

  /// 批量插入 ChatMessage 列表
  Future<void> insertChatMessages(List<ChatMessage> messages) async {
    final keys = (await _chatMessageBox.addAll(messages)).toList();
    for (var i = 0; i < messages.length; i++) {
      messages[i].id = keys[i];
      await messages[i].save();
    }
  }

  /// 更新 ChatMessage
  Future<void> updateChatMessage(ChatMessage message) async {
    await message.save();
  }

  /// 删除单条 ChatMessage
  Future<void> deleteChatMessage(int id) async {
    await _chatMessageBox.delete(id);
  }

  /// 删除某个会话下的所有消息
  Future<void> deleteMessagesBySessionId(int sessionId) async {
    final keysToDelete = _chatMessageBox.values
        .where((msg) => msg.sessionId == sessionId)
        .map((msg) => msg.id)
        .toList();
    await _chatMessageBox.deleteAll(keysToDelete);
  }

  /// 搜索消息内容包含关键字的记录
  List<ChatMessage> searchMessages(String query) {
    return _chatMessageBox.values
        .where((msg) => msg.content.contains(query))
        .toList();
  }
}
