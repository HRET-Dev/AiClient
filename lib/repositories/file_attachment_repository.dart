import 'package:ai_client/database/app_database.dart';

class FileAttachmentRepository {
  final AppDatabase _database;

  FileAttachmentRepository(this._database);

  // 获取消息的所有附件
  Future<List<FileAttachment>> getAttachmentsByMessageId(int messageId) async {
    return await (_database.select(_database.fileAttachments)
          ..where((t) => t.messageId.equals(messageId)))
        .get();
  }

  // 获取单个附件
  Future<FileAttachment?> getAttachmentById(int id) async {
    return await (_database.select(_database.fileAttachments)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // 创建新附件
  Future<int> createAttachment(FileAttachmentsCompanion attachment) async {
    return await _database.into(_database.fileAttachments).insert(attachment);
  }

  // 更新附件
  Future<bool> updateAttachment(FileAttachment attachment) async {
    return await _database.update(_database.fileAttachments).replace(attachment);
  }

  // 删除附件
  Future<int> deleteAttachment(int id) async {
    return await (_database.delete(_database.fileAttachments)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  // 删除消息的所有附件
  Future<int> deleteAttachmentsByMessageId(int messageId) async {
    return await (_database.delete(_database.fileAttachments)
          ..where((t) => t.messageId.equals(messageId)))
        .go();
  }

  // 根据文件类型获取附件
  Future<List<FileAttachment>> getAttachmentsByFileType(String fileType) async {
    return await (_database.select(_database.fileAttachments)
          ..where((t) => t.fileType.equals(fileType)))
        .get();
  }
}