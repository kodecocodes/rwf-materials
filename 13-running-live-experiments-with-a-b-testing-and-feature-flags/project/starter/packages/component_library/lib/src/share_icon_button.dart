import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class ShareIconButton extends StatelessWidget {
  const ShareIconButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = ComponentLibraryLocalizations.of(context);
    return IconButton(
      onPressed: onTap,
      tooltip: l10n.shareIconButtonTooltip,
      icon: const Icon(
        Icons.share,
      ),
    );
  }
}
