part of './profile_menu_screen.dart';

class DarkModePreferencePicker extends StatelessWidget {
  const DarkModePreferencePicker({
    required this.currentValue,
    Key? key,
  }) : super(key: key);

  final DarkModePreference currentValue;

  @override
  Widget build(BuildContext context) {
    // TODO: Get a ProfileMenuLocalizations instance.
    final bloc = context.read<ProfileMenuBloc>();
    return Column(
      children: [
        ListTile(
          title: Text(
            'Dark Mode Preferences',
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
                'Always Dark',
              ),
              value: DarkModePreference.alwaysDark,
              groupValue: currentValue,
              onChanged: (newOption) {
                bloc.add(
                  const ProfileMenuDarkModePreferenceChanged(
                    DarkModePreference.alwaysDark,
                  ),
                );
              },
            ),
            RadioListTile<DarkModePreference>(
              title: Text(
                'Always Light',
              ),
              value: DarkModePreference.alwaysLight,
              groupValue: currentValue,
              onChanged: (newOption) {
                bloc.add(
                  const ProfileMenuDarkModePreferenceChanged(
                    DarkModePreference.alwaysLight,
                  ),
                );
              },
            ),
            RadioListTile<DarkModePreference>(
              title: Text(
                'Use System Settings',
              ),
              value: DarkModePreference.useSystemSettings,
              groupValue: currentValue,
              onChanged: (newOption) {
                bloc.add(
                  const ProfileMenuDarkModePreferenceChanged(
                    DarkModePreference.useSystemSettings,
                  ),
                );
              },
            ),
          ],
          context: context,
        ),
      ],
    );
  }
}
