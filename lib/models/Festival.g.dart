// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Festival.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FestivalAdapter extends TypeAdapter<Festival> {
  @override
  final int typeId = 1;

  @override
  Festival read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Festival(
      endDate: fields[0] as DateTime?,
      magazine_src: fields[1] as String,
      news_src: fields[2] as String,
      startDate: fields[3] as DateTime?,
      subtitle: fields[4] as String,
      title: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Festival obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.endDate)
      ..writeByte(1)
      ..write(obj.magazine_src)
      ..writeByte(2)
      ..write(obj.news_src)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.subtitle)
      ..writeByte(5)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FestivalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
