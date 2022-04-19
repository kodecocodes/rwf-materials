import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _userTokenKey = 'fav-qs-user-token';

  const UserSecureStorage({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  Future<void> upsertUserToken(String token) => _secureStorage.write(
        key: _userTokenKey,
        value: token,
      );

  Future<void> deleteUserToken() => _secureStorage.delete(
        key: _userTokenKey,
      );

  Future<String?> getUserToken() => _secureStorage.read(
        key: _userTokenKey,
      );
}
