import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Useful for changing the status bar color when the screen doesn't have an
// AppBar. For screens with AppBars, please use the [] property.
class StyledStatusBar extends StatelessWidget {
  const StyledStatusBar._({
    required this.child,
    required this.style,
    Key? key,
  }) : super(key: key);

  const StyledStatusBar.light({
    required Widget child,
    Key? key,
  }) : this._(
          child: child,
          style: SystemUiOverlayStyle.light,
          key: key,
        );

  const StyledStatusBar.dark({
    required Widget child,
    Key? key,
  }) : this._(
          child: child,
          style: SystemUiOverlayStyle.dark,
          key: key,
        );

  final Widget child;
  final SystemUiOverlayStyle style;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: child,
    );
  }
}
