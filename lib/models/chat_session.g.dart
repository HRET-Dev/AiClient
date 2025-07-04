// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatSessionAdapter extends TypeAdapter<ChatSession> {
  @override
  final int typeId = 1;

  @override
  ChatSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatSession()
      ..id = fields[1] as int
      ..title = fields[2] as String
      ..apiConfigId = fields[3] as int
      ..model = fields[4] as String
      ..createTime = fields[5] as DateTime
      ..updateTime = fields[6] as DateTime
      ..isFavorite = fields[7] as bool;
  }

  @override
  void write(BinaryWriter writer, ChatSession obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.apiConfigId)
      ..writeByte(4)
      ..write(obj.model)
      ..writeByte(5)
      ..write(obj.createTime)
      ..writeByte(6)
      ..write(obj.updateTime)
      ..writeByte(7)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
