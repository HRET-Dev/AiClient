import 'dart:io';
import 'dart:convert';
import 'package:ai_client/models/chat_message.dart';
import 'package:ai_client/models/chat_session.dart';
import 'package:path_provider/path_provider.dart';
import '../repositories/chat_session_repository.dart';
import '../repositories/chat_message_repository.dart';

class ChatSessionService {
  final ChatSessionRepository _sessionRepository = ChatSessionRepository();
  final ChatMessageRepository _messageRepository = ChatMessageRepository();

  ChatSessionService();

  // 获取所有会话
  Future<List<ChatSession>> getAllSessions() async {
    return _sessionRepository.getAllSessions();
  }

  // 获取收藏的会话
  Future<List<ChatSession>> getFavoriteSessions() async {
    return _sessionRepository.getFavoriteSessions();
  }

  // 根据ID获取会话
  Future<ChatSession?> getSessionById(int id) async {
    return _sessionRepository.getSessionById(id);
  }

  // 创建新会话
  Future<int> createSession(String title,
      {int? apiConfigId, String? model}) async {
    final session = ChatSession()
      ..title = title
      ..apiConfigId = apiConfigId ?? 0
      ..model = model ?? ""
      ..createTime = DateTime.now()
      ..updateTime = DateTime.now();
    return await _sessionRepository.insertSession(session);
  }

  // 更新会话参数
  Future<void> updateSession(int id, {int? apiConfigId, String? model}) async {
    final session = _sessionRepository.getSessionById(id);
    if (session != null) {
      session
        ..apiConfigId = apiConfigId ?? 0
        ..model = model ?? ""
        ..updateTime = DateTime.now();
      await _sessionRepository.updateSession(session);
    }
  }

  // 更新会话标题
  Future<void> updateSessionTitle(int id, String title) async {
    final session = _sessionRepository.getSessionById(id);
    if (session != null) {
      session
        ..title = title
        ..updateTime = DateTime.now();
      await _sessionRepository.updateSession(session);
    }
  }

  // 删除会话及其所有消息
  Future<void> deleteSession(int id) async {
    // 先删除会话的所有消息
    await _messageRepository.deleteMessagesBySessionId(id);
    // 再删除会话
    await _sessionRepository.deleteSession(id);
  }

  // 搜索会话
  Future<List<ChatSession>> searchSessions(String query) async {
    if (query.isEmpty) {
      return await getAllSessions();
    }
    return _sessionRepository.searchSessions(query);
  }

  // 切换收藏状态
  Future<bool> toggleFavorite(int id) async {
    return await _sessionRepository.toggleFavorite(id);
  }

  // 导出会话为JSON文件
  Future<String?> exportSessionToJson(int id) async {
    try {
      final session = _sessionRepository.getSessionById(id);
      if (session == null) return null;

      final messages = _messageRepository.getMessagesBySessionId(id);

      final Map<String, dynamic> exportData = {
        'session': {
          'id': session.id,
          'title': session.title,
          'createTime': session.createTime.toIso8601String(),
          'updateTime': session.updateTime.toIso8601String(),
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
                  'createTime': msg.createTime.toIso8601String(),
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
      final session = ChatSession()
        ..title = sessionData['title']
        ..apiConfigId = sessionData['apiConfigId']
        ..model = sessionData['model']
        ..createTime = DateTime.parse(sessionData['createTime'])
        ..updateTime = DateTime.parse(sessionData['updateTime'])
        ..isFavorite = sessionData['isFavorite'] ?? false;

      final sessionId = await _sessionRepository.insertSession(session);

      // 导入消息
      final messagesData = importData['messages'] as List;
      for (var msgData in messagesData) {
        final message = ChatMessage()
          ..sessionId = sessionId
          ..content = msgData['content']
          ..type = MessageType.values.firstWhere(
            (e) => e.toString() == msgData['type'],
            orElse: () => MessageType.text,
          )
          ..role = MessageRole.values.firstWhere(
            (e) => e.toString() == msgData['role'],
            orElse: () => MessageRole.user,
          )
          ..createTime = DateTime.parse(msgData['createTime'])
          ..filePath = msgData['filePath']
          ..status = convertStatus(msgData['status']);

        await _messageRepository.insertChatMessage(message);
      }

      return sessionId;
    } catch (e) {
      print('导入会话失败: $e');
      return null;
    }
  }
}
