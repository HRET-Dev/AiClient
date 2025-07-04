// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_api.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AiApiAdapter extends TypeAdapter<AiApi> {
  @override
  final int typeId = 0;

  @override
  AiApi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AiApi()
      ..id = fields[0] as int
      ..serviceName = fields[1] as String
      ..provider = fields[2] as String
      ..baseUrl = fields[3] as String
      ..apiKey = fields[4] as String
      ..models = fields[5] as String
      ..isActive = fields[6] as bool
      ..createTime = fields[7] as DateTime
      ..updateTime = fields[8] as DateTime;
  }

  @override
  void write(BinaryWriter writer, AiApi obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serviceName)
      ..writeByte(2)
      ..write(obj.provider)
      ..writeByte(3)
      ..write(obj.baseUrl)
      ..writeByte(4)
      ..write(obj.apiKey)
      ..writeByte(5)
      ..write(obj.models)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.createTime)
      ..writeByte(8)
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AiApiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
