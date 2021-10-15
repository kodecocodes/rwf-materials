import 'package:async/async.dart';
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
  final BehaviorSubject<User?> _userSubject = BehaviorSubject();
  final BehaviorSubject<DarkModePreference> _darkModePreferenceSubject =
      BehaviorSubject();
  late final AsyncMemoizer _userTokenNormalizationMemoizer = AsyncMemoizer()
    ..runOnce(
      () async {
        // If the app is uninstalled while the user was authenticated, we need to
        // manually delete the token from our secure storage, since it persists
        // between app installs.
        final user = await _localStorage.getUser();
        if (user == null) {
          await _secureStorage.deleteUserToken();
        }
      },
    );

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
    try {
      final user = await remoteApi.signIn(
        email,
        password,
      );

      final cacheUser = user.toCacheModel();
      await Future.wait([
        _secureStorage.upsertUserToken(
          user.token,
        ),
        _localStorage.upsertUser(
          cacheUser,
        )
      ]);

      _userSubject.add(
        cacheUser.toDomainModel(),
      );
    } on InvalidCredentialsFavQsException catch (_) {
      throw InvalidCredentialsException();
    }
  }

  Stream<User?> getUser() async* {
    if (!_userSubject.hasValue) {
      final cachedUser = await _localStorage.getUser();
      _userSubject.add(cachedUser?.toDomainModel());
    }

    yield* _userSubject.stream;
  }

  Future<void> signUp(String username,
      String email,
      String password,) async {
    try {
      final userToken = await remoteApi.signUp(
        username,
        email,
        password,
      );

      final cacheUser = UserCM(
        username: username,
        email: email,
      );

      await Future.wait([
        _localStorage.upsertUser(
          cacheUser,
        ),
        _secureStorage.upsertUserToken(
          userToken,
        ),
      ]);

      _userSubject.add(
        cacheUser.toDomainModel(),
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

  Future<void> updateProfile(String username,
      String email,
      String? newPassword,) async {
    try {
      await remoteApi.updateProfile(
        username,
        email,
        newPassword,
      );
      final cacheUser = UserCM(
        username: username,
        email: email,
      );
      await _localStorage.upsertUser(cacheUser);

      _userSubject.add(
        cacheUser.toDomainModel(),
      );
    } on UsernameAlreadyTakenFavQsException catch (_) {
      throw UsernameAlreadyTakenException();
    }
  }

  Future<void> signOut() async {
    await remoteApi.signOut();
    await Future.wait(
      [
        _localStorage.deleteUser(),
        _secureStorage.deleteUserToken(),
      ],
    );
    _userSubject.add(null);
  }

  Future<void> requestPasswordResetEmail(String email) async {
    await remoteApi.requestPasswordResetEmail(email);
  }

  Future<String?> getUserToken() async {
    await _userTokenNormalizationMemoizer.future;
    final userToken = await _secureStorage.getUserToken();
    return userToken;
  }
}
