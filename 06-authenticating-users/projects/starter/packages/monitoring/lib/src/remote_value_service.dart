import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Wrapper around [FirebaseRemoteConfig].
class RemoteValueService {
  static const _darkModePreferencePickerEnabledKey =
      'dark_mode_preference_picker_enabled';

  RemoteValueService({
    @visibleForTesting FirebaseRemoteConfig? remoteConfig,
  }) : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  final FirebaseRemoteConfig _remoteConfig;

  Future<void> load() async {
    await _remoteConfig.setDefaults(<String, dynamic>{
      _darkModePreferencePickerEnabledKey: true,
    });
    await _remoteConfig.fetchAndActivate();
  }

  bool get shouldDisplayDarkModePreferencePicker => _remoteConfig.getBool(
        _darkModePreferencePickerEnabledKey,
      );
}
