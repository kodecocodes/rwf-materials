import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class AuthenticationRequiredErrorSnackBar extends SnackBar {
  const AuthenticationRequiredErrorSnackBar({Key? key})
      : super(
          key: key,
          content: const _AuthenticationRequiredErrorSnackBarMessage(),
        );
}

class _AuthenticationRequiredErrorSnackBarMessage extends StatelessWidget {
  const _AuthenticationRequiredErrorSnackBarMessage({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = ComponentLibraryLocalizations.of(context);
    return Text(
      l10n.authenticationRequiredErrorSnackbarMessage,
    );
  }
}
