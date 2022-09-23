import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:test/test.dart';
import 'package:user_repository/src/mappers/mappers.dart';

// Rund with: flutter test test/mappers_test.dart
void main() {
  group('Mapper test:', () {
    test(
        'When mapping DarkModePreferenceCM.alwaysDark to domain, return DarkModePreference.alwaysDark',
        () {
      final preference = DarkModePreferenceCM.alwaysDark;

      expect(preference.toDomainModel(), DarkModePreference.alwaysDark);
    });
  });
}
