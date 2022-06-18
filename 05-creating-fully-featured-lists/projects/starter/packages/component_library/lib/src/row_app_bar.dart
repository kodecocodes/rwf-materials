import 'package:component_library/component_library.dart';
import 'package:component_library/src/theme/spacing.dart';
import 'package:flutter/material.dart';

class RowAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RowAppBar({
    Key? key,
    this.children = const [],
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: Spacing.small,
          left: Spacing.small,
          right: Spacing.small,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackButton(),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
