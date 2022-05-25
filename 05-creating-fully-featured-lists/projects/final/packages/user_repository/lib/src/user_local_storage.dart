import 'package:key_value_storage/key_value_storage.dart';

class UserLocalStorage {
  UserLocalStorage({
    required this.noSqlStorage,
  });

  final KeyValueStorage noSqlStorage;

  Future<void> upsertDarkModePreference(DarkModePreferenceCM preference) async {
    final box = await noSqlStorage.darkModePreferenceBox;
    await box.put(0, preference);
  }

  Future<DarkModePreferenceCM?> getDarkModePreference() async {
    final box = await noSqlStorage.darkModePreferenceBox;
    return box.get(0);
  }

  Future<void> upsertUser(UserCM user) async {
    final box = await noSqlStorage.userBox;
    await box.put(0, user);
  }

  Future<UserCM?> getUser() async {
    final box = await noSqlStorage.userBox;
    return box.get(0);
  }

  Future<void> deleteUser() async {
    final box = await noSqlStorage.userBox;
    await box.clear();
  }
}
