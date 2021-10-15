import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

import 'component_book.dart';

void main() {
  runApp(StoryApp());
}

class StoryApp extends StatelessWidget {
  StoryApp({Key? key}) : super(key: key);

  final _lightTheme = LightWonderThemeData();
  final _darkTheme = DarkWonderThemeData();

  @override
  Widget build(BuildContext context) {
    return WonderTheme(
      lightTheme: _lightTheme,
      darkTheme: _darkTheme,
      child: ComponentBook(
        lightThemeData: _lightTheme.materialThemeData,
        darkThemeData: _darkTheme.materialThemeData,
      ),
    );
  }
}
