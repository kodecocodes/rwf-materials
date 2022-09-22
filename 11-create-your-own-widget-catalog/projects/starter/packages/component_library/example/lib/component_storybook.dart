import 'package:component_library/component_library.dart';
import 'package:component_library_storybook/stories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class ComponentStorybook extends StatelessWidget {
  final ThemeData lightThemeData, darkThemeData;

  const ComponentStorybook({
    Key? key,
    required this.lightThemeData,
    required this.darkThemeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Storybook(
      children: [
        ...getStories(theme),
      ],
      initialRoute: 'rounded-choice-chip',
    );
  }
}
