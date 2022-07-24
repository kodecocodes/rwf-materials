import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class UpvoteIconButton extends StatelessWidget {
  const UpvoteIconButton({
    required this.count,
    required this.isUpvoted,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final int count;
  final bool isUpvoted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = ComponentLibraryLocalizations.of(context);
    final theme = WonderTheme.of(context);
    return CountIndicatorIconButton(
      onTap: onTap,
      tooltip: l10n.upvoteIconButtonTooltip,
      iconData: Icons.arrow_upward_sharp,
      iconColor: isUpvoted ? theme.votedButtonColor : theme.unvotedButtonColor,
      count: count,
    );
  }
}
