import '../models/chat_message.dart';
import '../repositories/chat_message_repository.dart';
import '../repositories/chat_session_repository.dart';

class ChatMessageService {
  final ChatMessageRepository _messageRepository = ChatMessageRepository();
  final ChatSessionRepository _sessionRepository = ChatSessionRepository();

  ChatMessageService();

  // 获取会话的所有消息
  Future<List<ChatMessage>> getMessagesBySessionId(int sessionId) async {
    return _messageRepository.getMessagesBySessionId(sessionId);
  }

  // 获取单条消息
  Future<ChatMessage?> getMessageById(int id) async {
    return _messageRepository.getMessageById(id);
  }

  // 创建文本消息
  Future<int> createTextMessage({
    required int sessionId,
    required String content,
    required int apiConfigId,
    required String model,
    required MessageRole role,
    required MessageStatus status,
  }) async {
    // 创建消息
    final message = ChatMessage()
      ..sessionId = sessionId
      ..content = content
      ..apiConfigId = apiConfigId
      ..model = model
      ..type = MessageType.text
      ..role = role
      ..status = status;

    final messageId = _messageRepository.insertChatMessage(message);

    // 更新会话的最后更新时间
    final session = _sessionRepository.getSessionById(sessionId);
    if (session != null) {
      session.updateTime = DateTime.now();
      _sessionRepository.updateSession(session);
    }

    return messageId;
  }

  // 更新消息内容
  Future<void> updateMessageContent(int id, String content) async {
    final message = _messageRepository.getMessageById(id);
    if (message != null) {
      message.content = content;
      _messageRepository.updateChatMessage(message);
    }
  }

  // 更新消息状态
  Future<void> updateMessageStatus(int id, MessageStatus status) async {
    final message = _messageRepository.getMessageById(id);
    if (message != null) {
      message.status = status;
      _messageRepository.updateChatMessage(message);
    }
  }

  // 删除消息
  Future<void> deleteMessage(int id) async {
    _messageRepository.deleteChatMessage(id);
  }

  // 删除会话的所有消息
  Future<void> deleteMessagesBySessionId(int sessionId) async {
    _messageRepository.deleteMessagesBySessionId(sessionId);
  }

  // 搜索消息
  Future<List<ChatMessage>> searchMessages(String query) async {
    if (query.isEmpty) {
      return [];
    }
    return _messageRepository.searchMessages(query);
  }
}
