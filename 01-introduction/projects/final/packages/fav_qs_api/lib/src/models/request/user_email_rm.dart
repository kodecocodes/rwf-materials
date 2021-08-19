import 'package:json_annotation/json_annotation.dart';

part 'user_email_rm.g.dart';

@JsonSerializable(createFactory: false)
class UserEmailRM {
  const UserEmailRM({
    required this.email,
  });

  @JsonKey(name: 'email')
  final String email;

  Map<String, dynamic> toJson() => _$UserEmailRMToJson(this);
}
