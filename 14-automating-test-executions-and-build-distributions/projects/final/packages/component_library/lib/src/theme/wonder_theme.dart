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

  @override
  bool updateShouldNotify(
    WonderTheme oldWidget,
  ) =>
      oldWidget.lightTheme != lightTheme || oldWidget.darkTheme != darkTheme;

  static WonderThemeData of(BuildContext context) {
    final WonderTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<WonderTheme>();
    assert(inheritedTheme != null, 'No WonderTheme found in context');
    final currentBrightness = Theme.of(context).brightness;
    return currentBrightness == Brightness.dark
        ? inheritedTheme!.darkTheme
        : inheritedTheme!.lightTheme;
  }
}
