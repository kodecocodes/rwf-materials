import 'package:fav_qs_api/fav_qs_api.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension UserRMToCM on UserRM {
  UserCM toCacheModel() {
    return UserCM(
      username: username,
      email: email,
    );
  }
}
