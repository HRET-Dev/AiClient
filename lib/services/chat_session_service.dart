import 'dart:io';
import 'dart:convert';
import 'package:ai_client/models/chat_message.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ai_client/database/app_database.dart';
import '../repositories/chat_session_repository.dart';
import '../repositories/chat_message_repository.dart';

class ChatSessionService {
  final ChatSessionRepository _sessionRepository;
  final ChatMessageRepository _messageRepository;

  ChatSessionService(this._sessionRepository, this._messageRepository);

  // 获取所有会话
  Future<List<ChatSession>> getAllSessions() async {
    return await _sessionRepository.getAllSessions();
  }

  // 获取收藏的会话
  Future<List<ChatSession>> getFavoriteSessions() async {
    return await _sessionRepository.getFavoriteSessions();
  }

  // 根据ID获取会话
  Future<ChatSession?> getSessionById(int id) async {
    return await _sessionRepository.getSessionById(id);
  }

  // 创建新会话
  Future<int> createSession(String title,
      {int? apiConfigId, String? model}) async {
    final session = ChatSessionsCompanion.insert(
      title: title,
      apiConfigId:
          apiConfigId == null ? const Value.absent() : Value(apiConfigId),
      model: model == null ? const Value.absent() : Value(model),
    );
    return await _sessionRepository.createSession(session);
  }

  // 更新会话参数
  Future<void> updateSession(int id, {int? apiConfigId, String? model}) async {
    final session = await _sessionRepository.getSessionById(id);
    if (session != null) {
      final updatedSession = session.copyWith(
        apiConfigId:
            apiConfigId == null ? const Value.absent() : Value(apiConfigId),
        model: model == null ? const Value.absent() : Value(model),
        updatedTime: DateTime.now(),
      );
      await _sessionRepository.updateSession(updatedSession);
    }
  }

  // 更新会话标题
  Future<bool> updateSessionTitle(int id, String title) async {
    final session = await _sessionRepository.getSessionById(id);
    if (session != null) {
      final updatedSession = session.copyWith(
        title: title,
        updatedTime: DateTime.now(),
      );
      return await _sessionRepository.updateSession(updatedSession);
    }
    return false;
  }

  // 删除会话及其所有消息
  Future<bool> deleteSession(int id) async {
    // 先删除会话的所有消息
    await _messageRepository.deleteMessagesBySessionId(id);
    // 再删除会话
    final result = await _sessionRepository.deleteSession(id);
    return result > 0;
  }

  // 搜索会话
  Future<List<ChatSession>> searchSessions(String query) async {
    if (query.isEmpty) {
      return await getAllSessions();
    }
    return await _sessionRepository.searchSessions(query);
  }

  // 切换收藏状态
  Future<bool> toggleFavorite(int id) async {
    return await _sessionRepository.toggleFavorite(id);
  }

  // 导出会话为JSON文件
  Future<String?> exportSessionToJson(int id) async {
    try {
      final session = await _sessionRepository.getSessionById(id);
      if (session == null) return null;

      final messages = await _messageRepository.getMessagesBySessionId(id);

      final Map<String, dynamic> exportData = {
        'session': {
          'id': session.id,
          'title': session.title,
          'createdTime': session.createdTime.toIso8601String(),
          'updatedTime': session.updatedTime.toIso8601String(),
          'apiConfigId': session.apiConfigId,
          'model': session.model,
          'isFavorite': session.isFavorite,
        },
        'messages': messages
            .map((msg) => {
                  'id': msg.id,
                  'content': msg.content,
                  'type': msg.type.toString(),
                  'role': msg.role.toString(),
                  'createdTime': msg.createdTime.toIso8601String(),
                  'filePath': msg.filePath,
                  'status': msg.status,
                })
            .toList(),
      };

      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'chat_export_${session.id}_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(jsonEncode(exportData));
      return file.path;
    } catch (e) {
      print('导出会话失败: $e');
      return null;
    }
  }

  // 导入会话从JSON文件
  Future<int?> importSessionFromJson(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      final jsonString = await file.readAsString();
      final Map<String, dynamic> importData = jsonDecode(jsonString);

      // 创建新会话
      final sessionData = importData['session'] as Map<String, dynamic>;
      final session = ChatSessionsCompanion.insert(
        title: sessionData['title'],
        apiConfigId: sessionData['apiConfigId'] == null
            ? const Value.absent()
            : Value(sessionData['apiConfigId']),
        model: sessionData['model'] == null
            ? const Value.absent()
            : Value(sessionData['model']),
        createdTime: Value(DateTime.parse(sessionData['createdTime'])),
        updatedTime: Value(DateTime.parse(sessionData['updatedTime'])),
        isFavorite: Value(sessionData['isFavorite'] ?? false),
      );

      final sessionId = await _sessionRepository.createSession(session);

      // 导入消息
      final messagesData = importData['messages'] as List;
      for (var msgData in messagesData) {
        final message = ChatMessagesCompanion.insert(
          sessionId: sessionId,
          content: msgData['content'],
          type: MessageType.values.firstWhere(
            (e) => e.toString() == msgData['type'],
            orElse: () => MessageType.text,
          ),
          role: MessageRole.values.firstWhere(
            (e) => e.toString() == msgData['role'],
            orElse: () => MessageRole.user,
          ),
          createdTime: Value(DateTime.parse(msgData['createdTime'])),
          filePath: msgData['filePath'] == null
              ? const Value.absent()
              : Value(msgData['filePath']),
          status: convertStatus(msgData['status']),
        );

        await _messageRepository.createMessage(message);
      }

      return sessionId;
    } catch (e) {
      print('导入会话失败: $e');
      return null;
    }
  }
}
