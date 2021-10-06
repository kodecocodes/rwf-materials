import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class DownvoteIconButton extends StatelessWidget {
  const DownvoteIconButton({
    required this.count,
    required this.isDownvoted,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final int count;
  final VoidCallback? onTap;
  final bool isDownvoted;

  @override
  Widget build(BuildContext context) {
    final l10n = ComponentLibraryLocalizations.of(context);
    final theme = WonderTheme.of(context);
    return CountIndicatorIconButton(
      onTap: onTap,
      tooltip: l10n.downvoteIconButtonTooltip,
      iconData: Icons.arrow_downward_sharp,
      iconColor:
          isDownvoted ? theme.votedButtonColor : theme.unvotedButtonColor,
      count: count,
    );
  }
}
