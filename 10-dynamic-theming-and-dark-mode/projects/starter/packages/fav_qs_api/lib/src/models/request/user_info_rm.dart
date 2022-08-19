import 'package:json_annotation/json_annotation.dart';

part 'user_info_rm.g.dart';

@JsonSerializable(createFactory: false)
class UserInfoRM {
  const UserInfoRM({
    required this.username,
    required this.email,
    required this.password,
  });

  @JsonKey(name: 'login')
  final String username;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String? password;

  Map<String, dynamic> toJson() => _$UserInfoRMToJson(this);
}
