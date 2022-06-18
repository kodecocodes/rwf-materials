import 'package:fav_qs_api/src/models/request/user_credentials_rm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_in_request_rm.g.dart';

@JsonSerializable(createFactory: false)
class SignInRequestRM {
  const SignInRequestRM({
    required this.credentials,
  });

  @JsonKey(name: 'user')
  final UserCredentialsRM credentials;

  Map<String, dynamic> toJson() => _$SignInRequestRMToJson(this);
}
