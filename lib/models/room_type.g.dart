// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomTypeAdapter extends TypeAdapter<RoomType> {
  @override
  final int typeId = 0;

  @override
  RoomType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomType(
      fields[0] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, RoomType obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.islab);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
