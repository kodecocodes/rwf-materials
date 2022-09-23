import 'package:component_library/component_library.dart';
import 'package:component_library_storybook/component_storybook.dart';
import 'package:flutter/material.dart';

class StoryApp extends StatelessWidget {
  StoryApp({Key? key}) : super(key: key);

  final _lightTheme = LightWonderThemeData();
  final _darkTheme = DarkWonderThemeData();

  @override
  Widget build(BuildContext context) {
    return WonderTheme(
      lightTheme: _lightTheme,
      darkTheme: _darkTheme,
      child: ComponentStorybook(
        lightThemeData: _lightTheme.materialThemeData,
        darkThemeData: _darkTheme.materialThemeData,
      ),
    );
  }
}