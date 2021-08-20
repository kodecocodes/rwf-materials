// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_rm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRM _$UserRMFromJson(Map<String, dynamic> json) {
  return $checkedNew('UserRM', json, () {
    final val = UserRM(
      token: $checkedConvert(json, 'User-Token', (v) => v as String),
      username: $checkedConvert(json, 'login', (v) => v as String),
      email: $checkedConvert(json, 'email', (v) => v as String),
    );
    return val;
  }, fieldKeyMap: const {'token': 'User-Token', 'username': 'login'});
}
