import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _tokenKey = 'wonder-words-token';
  static const _usernameKey = 'wonder-words-username';
  static const _emailKey = 'wonder-words-email';

  const UserSecureStorage({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  Future<void> upsertUserInfo({
    required String username,
    required String email,
    String? token,
  }) =>
      Future.wait([
        _secureStorage.write(
          key: _emailKey,
          value: email,
        ),
        _secureStorage.write(
          key: _usernameKey,
          value: username,
        ),
        if (token != null)
          _secureStorage.write(
            key: _tokenKey,
            value: token,
          )
      ]);

  Future<void> deleteUserInfo() => Future.wait([
        _secureStorage.delete(
          key: _tokenKey,
        ),
        _secureStorage.delete(
          key: _usernameKey,
        ),
        _secureStorage.delete(
          key: _emailKey,
        ),
      ]);

  Future<String?> getUserToken() => _secureStorage.read(
        key: _tokenKey,
      );

  Future<String?> getUserEmail() => _secureStorage.read(
        key: _emailKey,
      );

  Future<String?> getUsername() => _secureStorage.read(
        key: _usernameKey,
      );
}
