// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteCMAdapter extends TypeAdapter<QuoteCM> {
  @override
  final int typeId = 0;

  @override
  QuoteCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuoteCM(
      id: fields[0] as int,
      body: fields[1] as String,
      favoritesCount: fields[6] as int,
      upvotesCount: fields[7] as int,
      downvotesCount: fields[8] as int,
      author: fields[2] as String?,
      isFavorite: fields[3] as bool?,
      isUpvoted: fields[4] as bool?,
      isDownvoted: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, QuoteCM obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.isFavorite)
      ..writeByte(4)
      ..write(obj.isUpvoted)
      ..writeByte(5)
      ..write(obj.isDownvoted)
      ..writeByte(6)
      ..write(obj.favoritesCount)
      ..writeByte(7)
      ..write(obj.upvotesCount)
      ..writeByte(8)
      ..write(obj.downvotesCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
