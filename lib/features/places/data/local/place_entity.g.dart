// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaceEntityAdapter extends TypeAdapter<PlaceEntity> {
  @override
  final typeId = 0;

  @override
  PlaceEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlaceEntity()
      ..remoteId = fields[0] as String
      ..name = fields[1] as String
      ..lat = (fields[2] as num).toDouble()
      ..lon = (fields[3] as num).toDouble()
      ..category = fields[4] as String?
      ..note = fields[5] as String?
      ..rating = (fields[6] as num).toInt()
      ..savedAt = fields[7] as DateTime;
  }

  @override
  void write(BinaryWriter writer, PlaceEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.remoteId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.lat)
      ..writeByte(3)
      ..write(obj.lon)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.rating)
      ..writeByte(7)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
