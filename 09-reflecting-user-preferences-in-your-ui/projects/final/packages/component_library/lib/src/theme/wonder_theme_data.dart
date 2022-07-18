import 'package:component_library/component_library.dart';
import 'package:component_library/src/theme/spacing.dart';
import 'package:flutter/material.dart';

const _dividerThemeData = DividerThemeData(
  space: 0,
);

// If the number of properties get too big, we can start grouping them in
// classes like Flutter does with TextTheme, ButtonTheme, etc, inside ThemeData.
abstract class WonderThemeData {
  ThemeData get materialThemeData;

  double screenMargin = Spacing.mediumLarge;

  double gridSpacing = Spacing.mediumLarge;

  Color get roundedChoiceChipBackgroundColor;

  Color get roundedChoiceChipSelectedBackgroundColor;

  Color get roundedChoiceChipLabelColor;

  Color get roundedChoiceChipSelectedLabelColor;

  Color get roundedChoiceChipAvatarColor;

  Color get roundedChoiceChipSelectedAvatarColor;

  Color get quoteSvgColor;

  Color get unvotedButtonColor;

  Color get votedButtonColor;

  TextStyle quoteTextStyle = const TextStyle(
    fontFamily: 'Fondamento',
    package: 'component_library',
  );
}

class LightWonderThemeData extends WonderThemeData {
  @override
  ThemeData get materialThemeData => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.black.toMaterialColor(),
        dividerTheme: _dividerThemeData,
      );

  @override
  Color get roundedChoiceChipBackgroundColor => Colors.white;

  @override
  Color get roundedChoiceChipLabelColor => Colors.black;

  @override
  Color get roundedChoiceChipSelectedBackgroundColor => Colors.black;

  @override
  Color get roundedChoiceChipSelectedLabelColor => Colors.white;

  @override
  Color get quoteSvgColor => Colors.black;

  @override
  Color get roundedChoiceChipAvatarColor => Colors.black;

  @override
  Color get roundedChoiceChipSelectedAvatarColor => Colors.white;

  @override
  Color get unvotedButtonColor => Colors.black54;

  @override
  Color get votedButtonColor => Colors.black;
}

class DarkWonderThemeData extends WonderThemeData {
  @override
  ThemeData get materialThemeData => ThemeData(
        brightness: Brightness.dark,
        toggleableActiveColor: Colors.white,
        primarySwatch: Colors.white.toMaterialColor(),
        dividerTheme: _dividerThemeData,
      );

  @override
  Color get roundedChoiceChipBackgroundColor => Colors.black;

  @override
  Color get roundedChoiceChipLabelColor => Colors.white;

  @override
  Color get roundedChoiceChipSelectedBackgroundColor => Colors.white;

  @override
  Color get roundedChoiceChipSelectedLabelColor => Colors.black;

  @override
  Color get quoteSvgColor => Colors.white;

  @override
  Color get roundedChoiceChipAvatarColor => Colors.white;

  @override
  Color get roundedChoiceChipSelectedAvatarColor => Colors.black;

  @override
  Color get unvotedButtonColor => Colors.white54;

  @override
  Color get votedButtonColor => Colors.white;
}

extension on Color {
  Map<int, Color> _toSwatch() => {
        50: withOpacity(0.1),
        100: withOpacity(0.2),
        200: withOpacity(0.3),
        300: withOpacity(0.4),
        400: withOpacity(0.5),
        500: withOpacity(0.6),
        600: withOpacity(0.7),
        700: withOpacity(0.8),
        800: withOpacity(0.9),
        900: this,
      };

  MaterialColor toMaterialColor() => MaterialColor(
        value,
        _toSwatch(),
      );
}
