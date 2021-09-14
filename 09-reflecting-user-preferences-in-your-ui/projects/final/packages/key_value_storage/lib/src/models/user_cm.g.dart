// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserCMAdapter extends TypeAdapter<UserCM> {
  @override
  final int typeId = 2;

  @override
  UserCM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCM(
      username: fields[0] as String,
      email: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserCM obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
