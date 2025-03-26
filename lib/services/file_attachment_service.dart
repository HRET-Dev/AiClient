import 'dart:io';
import 'package:ai_client/database/app_database.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../repositories/file_attachment_repository.dart';

class FileAttachmentService {
  final FileAttachmentRepository _attachmentRepository;

  FileAttachmentService(this._attachmentRepository);

  // 获取消息的所有附件
  Future<List<FileAttachment>> getAttachmentsByMessageId(int messageId) async {
    return await _attachmentRepository.getAttachmentsByMessageId(messageId);
  }

  // 获取单个附件
  Future<FileAttachment?> getAttachmentById(int id) async {
    return await _attachmentRepository.getAttachmentById(id);
  }

  // 上传文件并创建附件
  Future<int> uploadFile({
    required int messageId,
    required File file,
  }) async {
    try {
      // 获取应用文档目录
      final appDir = await getApplicationDocumentsDirectory();
      final attachmentsDir = Directory('${appDir.path}/attachments');
      if (!await attachmentsDir.exists()) {
        await attachmentsDir.create(recursive: true);
      }

      // 生成唯一文件名
      final fileName = path.basename(file.path);
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final targetPath = '${attachmentsDir.path}/$uniqueFileName';

      // 复制文件到应用目录
      final newFile = await file.copy(targetPath);
      final fileSize = await newFile.length();
      final fileType = path.extension(file.path).replaceAll('.', '');

      // 创建附件记录
      final attachment = FileAttachmentsCompanion.insert(
        messageId: messageId,
        fileName: fileName,
        filePath: targetPath,
        fileSize: fileSize,
        fileType: fileType,
      );

      return await _attachmentRepository.createAttachment(attachment);
    } catch (e) {
      print('上传文件失败: $e');
      rethrow;
    }
  }

  // 删除附件及其文件
  Future<bool> deleteAttachment(int id) async {
    try {
      final attachment = await _attachmentRepository.getAttachmentById(id);
      if (attachment != null) {
        // 删除文件
        final file = File(attachment.filePath);
        if (await file.exists()) {
          await file.delete();
        }
        
        // 删除数据库记录
        final result = await _attachmentRepository.deleteAttachment(id);
        return result > 0;
      }
      return false;
    } catch (e) {
      print('删除附件失败: $e');
      return false;
    }
  }

  // 删除消息的所有附件
  Future<bool> deleteAttachmentsByMessageId(int messageId) async {
    try {
      final attachments = await _attachmentRepository.getAttachmentsByMessageId(messageId);
      
      // 删除所有文件
      for (var attachment in attachments) {
        final file = File(attachment.filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }
      
      // 删除数据库记录
      final result = await _attachmentRepository.deleteAttachmentsByMessageId(messageId);
      return result > 0;
    } catch (e) {
      print('删除消息附件失败: $e');
      return false;
    }
  }

  // 根据文件类型获取附件
  Future<List<FileAttachment>> getAttachmentsByFileType(String fileType) async {
    return await _attachmentRepository.getAttachmentsByFileType(fileType);
  }

  // 获取文件大小的可读字符串
  String getReadableFileSize(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double size = bytes.toDouble();
    
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(2)} ${suffixes[i]}';
  }
}