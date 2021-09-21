import 'package:component_library/component_library.dart';
import 'package:component_library/src/mixins/animation_mixin.dart';
import 'package:flutter/material.dart';

class RoundedChoiceChip extends StatefulWidget {
  const RoundedChoiceChip({
    required this.label,
    required this.isSelected,
    this.avatar,
    this.labelColor,
    this.selectedLabelColor,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.onSelected,
    Key? key,
  }) : super(key: key);

  final String label;
  final Widget? avatar;
  final ValueChanged<bool>? onSelected;
  final Color? labelColor;
  final Color? selectedLabelColor;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final bool isSelected;

  @override
  State<RoundedChoiceChip> createState() => _RoundedChoiceChipState();
}

class _RoundedChoiceChipState extends State<RoundedChoiceChip>
    with SingleTickerProviderStateMixin, ScaleAnimationMixin {
  @override
  double get scaleTo => 0.9;

  @override
  Widget build(BuildContext context) {
    final WonderThemeData theme = WonderTheme.of(context);
    return ScaleTransition(
      scale: scaleAnimation,
      child: ChoiceChip(
        shape: const StadiumBorder(
          side: BorderSide(),
        ),
        avatar: widget.avatar,
        label: Text(
          widget.label,
          style: TextStyle(
            color: widget.isSelected
                ? (widget.selectedLabelColor ??
                    theme.roundedChoiceChipSelectedLabelColor)
                : (widget.labelColor ?? theme.roundedChoiceChipLabelColor),
          ),
        ),
        onSelected: (isSelected) {
          widget.onSelected?.call(isSelected);
          animate();
        },
        selected: widget.isSelected,
        backgroundColor:
            (widget.backgroundColor ?? theme.roundedChoiceChipBackgroundColor),
        selectedColor: (widget.selectedBackgroundColor ??
            theme.roundedChoiceChipSelectedBackgroundColor),
      ),
    );
  }
}
