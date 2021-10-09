import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class ComponentBook extends StatelessWidget {
  final ThemeData lightThemeData, darkThemeData;

  const ComponentBook({
    Key? key,
    required this.lightThemeData,
    required this.darkThemeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Storybook(
        theme: lightThemeData,
        darkTheme: darkThemeData,
        localizationDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          ComponentLibraryLocalizations.delegate,
        ],
        children: [
          Story(
            name: 'ChevronListTile',
            padding: const EdgeInsets.all(Spacing.medium),
            builder: (_, k) => ChevronListTile(
              label: k.text(
                label: 'Chevron List Tile Label',
                initial: 'Update Profile',
              ),
            ),
          ),
          Story(
            name: 'CountIndicatorIconButton',
            builder: (_, k) => CountIndicatorIconButton(
              count: k.sliderInt(label: 'Count'),
              iconData: k.options(
                label: 'Icon Data',
                initial: Icons.arrow_upward,
                options: const [
                  Option('Upward', Icons.arrow_upward),
                  Option('Red accent', Icons.arrow_downward),
                ],
              ),
              tooltip: k.text(label: 'Tooltip', initial: 'Count indicator'),
              onTap: k.boolean(label: 'Enabled', initial: true) ? () {} : null,
            ),
          ),
          Story.simple(
            name: 'CenteredCircularProgressIndicator',
            child: const CenteredCircularProgressIndicator(),
          ),
        ],
      );
}
