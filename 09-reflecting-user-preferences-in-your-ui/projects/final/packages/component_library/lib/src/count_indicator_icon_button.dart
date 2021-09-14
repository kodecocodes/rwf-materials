import 'package:component_library/component_library.dart';
import 'package:component_library/src/mixins/animation_mixin.dart';
import 'package:flutter/material.dart';

class CountIndicatorIconButton extends StatefulWidget {
  const CountIndicatorIconButton({
    required this.count,
    required this.iconData,
    this.iconColor,
    this.tooltip,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final int count;
  final IconData iconData;
  final Color? iconColor;
  final String? tooltip;
  final VoidCallback? onTap;

  @override
  State<CountIndicatorIconButton> createState() =>
      _CountIndicatorIconButtonState();
}

class _CountIndicatorIconButtonState extends State<CountIndicatorIconButton>
    with SingleTickerProviderStateMixin, ScaleAnimationMixin {
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: IconButton(
        onPressed: () {
          widget.onTap?.call();
          animate();
        },
        tooltip: widget.tooltip,
        padding: const EdgeInsets.all(0),
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.iconData,
              color: widget.iconColor,
            ),
            Text(
              widget.count.toString(),
              style: const TextStyle(
                fontSize: FontSize.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
