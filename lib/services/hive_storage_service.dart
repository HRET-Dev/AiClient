import 'package:ai_client/models/ai_api.dart';
import 'package:ai_client/models/chat_message.dart';
import 'package:ai_client/models/chat_session.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 数据库存储服务
class HiveStorageService {
  static late Box<AiApi> aiApiBox;
  static late Box<ChatSession> chatSessionBox;
  static late Box<ChatMessage> chatMessageBox;

  static Future<void> init() async {
    // 初始化Hive
    await Hive.initFlutter();

    // 注册模型 Adapter
    Hive.registerAdapter(AiApiAdapter());
    Hive.registerAdapter(ChatSessionAdapter());
    Hive.registerAdapter(ChatMessageAdapter());

    // 注册枚举 Adapter
    Hive.registerAdapter(MessageTypeAdapter());
    Hive.registerAdapter(MessageRoleAdapter());
    Hive.registerAdapter(MessageStatusAdapter());

    // 打开盒子
    aiApiBox = await Hive.openBox<AiApi>('aiApi');
    chatSessionBox = await Hive.openBox<ChatSession>('chatSession');
    chatMessageBox = await Hive.openBox<ChatMessage>('chatMessage');
  }
}
