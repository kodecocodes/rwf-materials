import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class RoundedChoiceChip extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = WonderTheme.of(context);
    return ChoiceChip(
      shape: const StadiumBorder(
        side: BorderSide(),
      ),
      avatar: avatar,
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? (selectedLabelColor ??
                  theme.roundedChoiceChipSelectedLabelColor)
              : (labelColor ?? theme.roundedChoiceChipLabelColor),
        ),
      ),
      onSelected: onSelected,
      selected: isSelected,
      backgroundColor:
          (backgroundColor ?? theme.roundedChoiceChipBackgroundColor),
      selectedColor: (selectedBackgroundColor ??
          theme.roundedChoiceChipSelectedBackgroundColor),
    );
  }
}
