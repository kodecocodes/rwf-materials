import 'package:component_library/component_library.dart';
import 'package:component_library/src/mixins/animation_mixin.dart';
import 'package:flutter/material.dart';

class FavoriteIconButton extends StatefulWidget {
  const FavoriteIconButton({
    required this.isFavorite,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  State<FavoriteIconButton> createState() => _FavoriteIconButtonState();
}

class _FavoriteIconButtonState extends State<FavoriteIconButton>
    with SingleTickerProviderStateMixin, ScaleAnimationMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = ComponentLibraryLocalizations.of(context);
    return ScaleTransition(
      scale: scaleAnimation,
      child: IconButton(
        onPressed: () {
          widget.onTap?.call();
          animate();
        },
        tooltip: l10n.favoriteIconButtonTooltip,
        icon: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
        ),
      ),
    );
  }
}
