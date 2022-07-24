import 'package:fav_qs_api/src/models/request/user_email_rm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'password_reset_email_request_rm.g.dart';

@JsonSerializable(createFactory: false)
class PasswordResetEmailRequestRM {
  const PasswordResetEmailRequestRM({
    required this.user,
  });

  @JsonKey(name: 'user')
  final UserEmailRM user;

  Map<String, dynamic> toJson() => _$PasswordResetEmailRequestRMToJson(this);
}
