import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile_menu/profile_menu.dart';
import 'package:profile_menu/src/profile_menu_bloc.dart';

class DarkModePreferencePicker extends StatelessWidget {
  const DarkModePreferencePicker({
    required this.currentValue,
    Key? key,
  }) : super(key: key);

  final DarkModePreference currentValue;

  @override
  Widget build(BuildContext context) {
    final l10n = ProfileMenuLocalizations.of(context);
    //TODO: read the bloc
    return Column(
      children: [
        ListTile(
          title: Text(
            l10n.darkModePreferencesHeaderTileLabel,
            style: const TextStyle(
              fontSize: FontSize.mediumLarge,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        ...ListTile.divideTiles(
          tiles: [
            RadioListTile<DarkModePreference>(
              title: Text(
                l10n.darkModePreferencesAlwaysDarkTileLabel,
              ),
              value: DarkModePreference.alwaysDark,
              groupValue: currentValue,
              onChanged: (newOption) {
                //TODO: trigger the preference change event for 1st radio tile
              },
            ),
            RadioListTile<DarkModePreference>(
              title: Text(
                l10n.darkModePreferencesAlwaysLightTileLabel,
              ),
              value: DarkModePreference.alwaysLight,
              groupValue: currentValue,
              onChanged: (newOption) {
                //TODO: trigger the preference change event for 2nd radio tile
              },
            ),
            RadioListTile<DarkModePreference>(
              title: Text(
                l10n.darkModePreferencesUseSystemSettingsTileLabel,
              ),
              value: DarkModePreference.useSystemSettings,
              groupValue: currentValue,
              onChanged: (newOption) {
                //TODO: trigger the preference change event for 3rd radio tile
              },
            ),
          ],
          context: context,
        ),
      ],
    );
  }
}
