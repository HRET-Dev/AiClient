import 'package:ai_client/database/app_database.dart';
import 'package:drift/drift.dart';
import '../models/chat_message.dart';
import '../repositories/chat_message_repository.dart';
import '../repositories/chat_session_repository.dart';

class ChatMessageService {
  final ChatMessageRepository _messageRepository;
  final ChatSessionRepository _sessionRepository;

  ChatMessageService(this._messageRepository, this._sessionRepository);

  // 获取会话的所有消息
  Future<List<ChatMessage>> getMessagesBySessionId(int sessionId) async {
    return await _messageRepository.getMessagesBySessionId(sessionId);
  }

  // 获取单条消息
  Future<ChatMessage?> getMessageById(int id) async {
    return await _messageRepository.getMessageById(id);
  }

  // 创建文本消息
  Future<int> createTextMessage({
    required int sessionId,
    required String content,
    required MessageRole role,
  }) async {
    final message = ChatMessagesCompanion.insert(
      sessionId: sessionId,
      content: content,
      type: MessageType.text,
      role: role,
    );
    
    final messageId = await _messageRepository.createMessage(message);
    
    // 更新会话的最后更新时间
    final session = await _sessionRepository.getSessionById(sessionId);
    if (session != null) {
      await _sessionRepository.updateSession(
        session.copyWith(updatedTime: DateTime.now())
      );
    }
    
    return messageId;
  }

  // 创建图片消息
  Future<int> createImageMessage({
    required int sessionId,
    required String content,
    required MessageRole role,
    required String imagePath,
  }) async {
    final message = ChatMessagesCompanion.insert(
      sessionId: sessionId,
      content: content,
      type: MessageType.image,
      role: role,
      filePath: Value(imagePath),
    );
    
    final messageId = await _messageRepository.createMessage(message);
    
    // 更新会话的最后更新时间
    final session = await _sessionRepository.getSessionById(sessionId);
    if (session != null) {
      await _sessionRepository.updateSession(
        session.copyWith(updatedTime: DateTime.now())
      );
    }
    
    return messageId;
  }

  // 创建文件消息
  Future<int> createFileMessage({
    required int sessionId,
    required String content,
    required MessageRole role,
    required String filePath,
  }) async {
    final message = ChatMessagesCompanion.insert(
      sessionId: sessionId,
      content: content,
      type: MessageType.file,
      role: role,
      filePath: Value(filePath),
    );
    
    final messageId = await _messageRepository.createMessage(message);
    
    // 更新会话的最后更新时间
    final session = await _sessionRepository.getSessionById(sessionId);
    if (session != null) {
      await _sessionRepository.updateSession(
        session.copyWith(updatedTime: DateTime.now())
      );
    }
    
    return messageId;
  }

  // 更新消息内容
  Future<bool> updateMessageContent(int id, String content) async {
    final message = await _messageRepository.getMessageById(id);
    if (message != null) {
      final updatedMessage = message.copyWith(content: content);
      return await _messageRepository.updateMessage(updatedMessage);
    }
    return false;
  }

  // 更新消息状态
  Future<bool> updateMessageStatus(int id, String status) async {
    final message = await _messageRepository.getMessageById(id);
    if (message != null) {
      final updatedMessage = message.copyWith(status: status);
      return await _messageRepository.updateMessage(updatedMessage);
    }
    return false;
  }

  // 删除消息
  Future<bool> deleteMessage(int id) async {
    final result = await _messageRepository.deleteMessage(id);
    return result > 0;
  }

  // 删除会话的所有消息
  Future<bool> deleteMessagesBySessionId(int sessionId) async {
    final result = await _messageRepository.deleteMessagesBySessionId(sessionId);
    return result > 0;
  }

  // 搜索消息
  Future<List<ChatMessage>> searchMessages(String query) async {
    if (query.isEmpty) {
      return [];
    }
    return await _messageRepository.searchMessages(query);
  }

  // 将ChatMessage转换为ChatMessageInfo
  ChatMessageInfo convertToMessageInfo(ChatMessage message, {String defaultModelName = 'Unknown'}) {
    return ChatMessageInfo(
      content: message.content,
      isUser: message.role == MessageRole.user,
      modelName: defaultModelName,
      createdTime: message.createdTime,
    );
  }
}