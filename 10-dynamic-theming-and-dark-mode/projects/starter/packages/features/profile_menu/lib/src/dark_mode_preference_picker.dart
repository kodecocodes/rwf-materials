part of './profile_menu_screen.dart';

class DarkModePreferencePicker extends StatelessWidget {
  const DarkModePreferencePicker({
    required this.currentValue,
    Key? key,
  }) : super(key: key);

  final DarkModePreference currentValue;

  @override
  Widget build(BuildContext context) {
    final l10n = ProfileMenuLocalizations.of(context);
    final bloc = context.read<ProfileMenuBloc>();
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
              // TODO: set correct group value
              groupValue: null,
              onChanged: (newOption) {
                // TODO: add ProfileMenuDarkModePreferenceChanged triggering for dark mode
              },
            ),
            RadioListTile<DarkModePreference>(
              title: Text(
                l10n.darkModePreferencesAlwaysLightTileLabel,
              ),
              value: DarkModePreference.alwaysLight,
              // TODO: set correct group value
              groupValue: null,
              onChanged: (newOption) {
                // TODO: add ProfileMenuDarkModePreferenceChanged triggering for light mode
              },
            ),
            RadioListTile<DarkModePreference>(
              title: Text(
                l10n.darkModePreferencesUseSystemSettingsTileLabel,
              ),
              value: DarkModePreference.useSystemSettings,
              // TODO: set correct group value
              groupValue: null,
              onChanged: (newOption) {
                // TODO: add ProfileMenuDarkModePreferenceChanged triggering for system mode
              },
            ),
          ],
          context: context,
        ),
      ],
    );
  }
}
