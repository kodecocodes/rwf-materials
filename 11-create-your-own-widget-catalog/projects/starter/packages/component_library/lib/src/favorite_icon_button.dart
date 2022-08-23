import 'package:component_library/component_library.dart';
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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  double scaleFrom = 1.0, scaleTo = 0.8;
  double partition = 0.7;
  Duration duration = kThemeAnimationDuration;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
          tween: Tween(begin: scaleFrom, end: scaleTo),
          weight: partition,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: scaleTo, end: scaleFrom),
          weight: 1 - partition,
        )
      ],
    ).animate(_controller);
  }

  void animate() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ComponentLibraryLocalizations.of(context);
    return ScaleTransition(
      scale: _scaleAnimation,
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
