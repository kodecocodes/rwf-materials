// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRM _$UserRMFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserRM',
      json,
      ($checkedConvert) {
        final val = UserRM(
          token: $checkedConvert('User-Token', (v) => v as String),
          username: $checkedConvert('login', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'token': 'User-Token', 'username': 'login'},
    );
