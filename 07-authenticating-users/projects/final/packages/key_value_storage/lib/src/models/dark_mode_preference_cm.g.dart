// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dark_mode_preference_cm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DarkModePreferenceCMAdapter extends TypeAdapter<DarkModePreferenceCM> {
  @override
  final int typeId = 3;

  @override
  DarkModePreferenceCM read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DarkModePreferenceCM.alwaysDark;
      case 1:
        return DarkModePreferenceCM.alwaysLight;
      case 2:
        return DarkModePreferenceCM.accordingToSystemPreferences;
      default:
        return DarkModePreferenceCM.alwaysDark;
    }
  }

  @override
  void write(BinaryWriter writer, DarkModePreferenceCM obj) {
    switch (obj) {
      case DarkModePreferenceCM.alwaysDark:
        writer.writeByte(0);
        break;
      case DarkModePreferenceCM.alwaysLight:
        writer.writeByte(1);
        break;
      case DarkModePreferenceCM.accordingToSystemPreferences:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DarkModePreferenceCMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
