import 'package:fav_qs_api/fav_qs_api.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:user_repository/src/user_secure_storage.dart';
import 'package:user_repository/user_repository.dart';

import 'user_repository_test.mocks.dart';

@GenerateMocks([UserSecureStorage])
void main() {
  group('User authentication token:', () {
    final _userSecureStorage = MockUserSecureStorage();

    final _userRepository = UserRepository(
      secureStorage: _userSecureStorage,
      noSqlStorage: KeyValueStorage(),
      remoteApi: FavQsApi(
        userTokenSupplier: () => Future.value(),
      ),
    );

    test(
        'When calling getUserToken after successful authentication, return authentication token',
        () async {
      when(_userSecureStorage.getUserToken()).thenAnswer((_) async => 'token');

      expect(await _userRepository.getUserToken(), 'token');
    });
  });
}
