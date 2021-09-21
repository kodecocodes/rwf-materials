import 'package:component_library/component_library.dart';
import 'package:component_library/src/theme/spacing.dart';
import 'package:flutter/material.dart';

const _dividerThemeData = DividerThemeData(
  space: 0,
);

ElevatedButtonThemeData get buttonThemeData => ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: const StadiumBorder().materialize(),
      ),
    );

// If the number of properties get too big, we can start grouping them in
// classes like Flutter does with TextTheme, ButtonTheme, etc, inside ThemeData.
abstract class WonderThemeData {
  ThemeData get materialThemeData;

  double screenMargin = Spacing.mediumLarge;

  double searchBarMargin = Spacing.xSmall;

  double gridSpacing = Spacing.mediumLarge;

  double listSpacing = Spacing.mediumLarge;

  double inputDecorationBorderRadius = Spacing.medium;

  Color get roundedChoiceChipBackgroundColor;

  Color get roundedChoiceChipSelectedBackgroundColor;

  Color get roundedChoiceChipLabelColor;

  Color get roundedChoiceChipSelectedLabelColor;

  Color get roundedChoiceChipAvatarColor;

  Color get roundedChoiceChipSelectedAvatarColor;

  Color get quoteSvgColor;

  Color get unvotedButtonColor;

  Color get votedButtonColor;

  Color get textFieldorderColor;

  MaterialColor get fabBackgroundColor;

  MaterialColor get fabForegroundColor;

  FloatingActionButtonThemeData get fabThemeData =>
      FloatingActionButtonThemeData(
        backgroundColor: fabBackgroundColor.shade600,
        foregroundColor: fabForegroundColor,
      );

  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: textFieldorderColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              inputDecorationBorderRadius,
            ),
          ),
        ),
      );

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
        floatingActionButtonTheme: fabThemeData,
        elevatedButtonTheme: buttonThemeData,
        inputDecorationTheme: inputDecorationTheme,
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

  @override
  MaterialColor get fabBackgroundColor => Colors.black.toMaterialColor();

  @override
  MaterialColor get fabForegroundColor => Colors.white.toMaterialColor();

  @override
  Color get textFieldorderColor => Colors.black;
}

class DarkWonderThemeData extends WonderThemeData {
  @override
  ThemeData get materialThemeData => ThemeData(
        brightness: Brightness.dark,
        toggleableActiveColor: Colors.white,
        primarySwatch: Colors.white.toMaterialColor(),
        dividerTheme: _dividerThemeData,
        floatingActionButtonTheme: fabThemeData,
        elevatedButtonTheme: buttonThemeData,
        inputDecorationTheme: inputDecorationTheme,
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

  @override
  MaterialColor get fabBackgroundColor => Colors.white.toMaterialColor();

  @override
  MaterialColor get fabForegroundColor => Colors.black.toMaterialColor();

  @override
  Color get textFieldorderColor => Colors.white;
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

extension OutlinedBorderExtensions on OutlinedBorder {
  MaterialStateProperty<OutlinedBorder> materialize() {
    return MaterialStateProperty.all<OutlinedBorder>(this);
  }
}