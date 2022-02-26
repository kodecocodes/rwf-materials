import 'package:fav_qs_api/fav_qs_api.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_user_request_rm.g.dart';

@JsonSerializable(createFactory: false)
class UpdateUserRequestRM {
  const UpdateUserRequestRM({
    required this.user,
  });

  @JsonKey(name: 'user')
  final UserInfoRM user;

  Map<String, dynamic> toJson() => _$UpdateUserRequestRMToJson(this);
}
