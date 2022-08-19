import 'package:component_library/src/theme/wonder_theme_data.dart';
import 'package:flutter/material.dart';

class WonderTheme extends InheritedWidget {
  const WonderTheme({
    required Widget child,
    required this.lightTheme,
    required this.darkTheme,
    Key? key,
  }) : super(
          key: key,
          child: child,
        );

  final WonderThemeData lightTheme;
  final WonderThemeData darkTheme;

  // TODO: replace with correct implementation of updateShouldNotify
  @override
  bool updateShouldNotify(WonderTheme oldWidget) {
    return false;
  }

  // TODO: replace with correct implementation of service locator function
  static WonderThemeData of(BuildContext context) {
    return LightWonderThemeData();
  }
}
