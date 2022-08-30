import 'package:domain_models/domain_models.dart';
import 'package:key_value_storage/key_value_storage.dart';

extension DarkModePreferenceCMToDomain on DarkModePreferenceCM {
  DarkModePreference toDomainModel() {
    switch (this) {
      case DarkModePreferenceCM.alwaysDark:
        return DarkModePreference.alwaysDark;
      case DarkModePreferenceCM.alwaysLight:
        return DarkModePreference.alwaysLight;
      case DarkModePreferenceCM.accordingToSystemPreferences:
        return DarkModePreference.useSystemSettings;
    }
  }
}
