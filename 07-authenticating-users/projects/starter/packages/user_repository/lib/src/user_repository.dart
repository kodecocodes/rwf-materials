import 'package:domain_models/domain_models.dart';
import 'package:fav_qs_api/fav_qs_api.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/src/mappers/mappers.dart';
import 'package:user_repository/src/user_local_storage.dart';
import 'package:user_repository/src/user_secure_storage.dart';

class UserRepository {
  UserRepository({
    required KeyValueStorage noSqlStorage,
    required this.remoteApi,
    @visibleForTesting UserLocalStorage? localStorage,
    @visibleForTesting UserSecureStorage? secureStorage,
  })  : _localStorage = localStorage ??
            UserLocalStorage(
              noSqlStorage: noSqlStorage,
            ),
        _secureStorage = secureStorage ?? const UserSecureStorage();

  final FavQsApi remoteApi;
  final UserLocalStorage _localStorage;
  final UserSecureStorage _secureStorage;
  final BehaviorSubject<DarkModePreference> _darkModePreferenceSubject =
      BehaviorSubject();
  // TODO: Create a listenable property.

  Future<void> upsertDarkModePreference(DarkModePreference preference) async {
    await _localStorage.upsertDarkModePreference(
      preference.toCacheModel(),
    );
    _darkModePreferenceSubject.add(preference);
  }

  Stream<DarkModePreference> getDarkModePreference() async* {
    if (!_darkModePreferenceSubject.hasValue) {
      final storedPreference = await _localStorage.getDarkModePreference();
      _darkModePreferenceSubject.add(
        storedPreference?.toDomainModel() ??
            DarkModePreference.useSystemSettings,
      );
    }

    yield* _darkModePreferenceSubject.stream;
  }

  Future<void> signIn(String email, String password) async {
    // TODO: Sign in the user by coordinating the Data Sources.
  }

  Stream<User?> getUser() async* {
    // TODO: Expose the BehaviorSubject.
  }

  Future<String?> getUserToken() async {
    // TODO: Provide the user token.
  }

  Future<void> signUp(
    String username,
    String email,
    String password,
  ) async {
    try {
      final userToken = await remoteApi.signUp(
        username,
        email,
        password,
      );

      await _secureStorage.upsertUserInfo(
        username: username,
        email: email,
        token: userToken,
      );

      _userSubject.add(
        User(
          username: username,
          email: email,
        ),
      );
    } catch (error) {
      if (error is UsernameAlreadyTakenFavQsException) {
        throw UsernameAlreadyTakenException();
      } else if (error is EmailAlreadyRegisteredFavQsException) {
        throw EmailAlreadyRegisteredException();
      }
      rethrow;
    }
  }

  Future<void> updateProfile(
    String username,
    String email,
    String? newPassword,
  ) async {
    try {
      await remoteApi.updateProfile(
        username,
        email,
        newPassword,
      );

      await _secureStorage.upsertUserInfo(
        username: username,
        email: email,
      );

      _userSubject.add(
        User(
          username: username,
          email: email,
        ),
      );
    } on UsernameAlreadyTakenFavQsException catch (_) {
      throw UsernameAlreadyTakenException();
    }
  }

  Future<void> signOut() async {
    await remoteApi.signOut();
    await _secureStorage.deleteUserInfo();
    _userSubject.add(null);
  }

  Future<void> requestPasswordResetEmail(String email) async {
    await remoteApi.requestPasswordResetEmail(email);
  }
}
