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
}
