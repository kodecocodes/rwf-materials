import 'package:component_library/component_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ExceptionIndicator extends StatelessWidget {
  const ExceptionIndicator({
    this.title,
    this.message,
    this.onTryAgain,
    Key? key,
  }) : super(key: key);

  final String? title;
  final String? message;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = ComponentLibraryLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 16,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 200,
              child: RiveAnimation.asset('assets/animations/on_off_switch.riv', animations: ['Off'],),
            ),
            const SizedBox(
              height: Spacing.medium,
            ),
            Text(
              title ?? l10n.exceptionIndicatorGenericTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: FontSize.mediumLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              title ?? l10n.exceptionIndicatorGenericMessage,
              textAlign: TextAlign.center,
            ),
            if (onTryAgain != null)
              const SizedBox(
                height: Spacing.xxxLarge,
              ),
            if (onTryAgain != null)
              ExpandedElevatedButton(
                onTap: onTryAgain,
                icon: const Icon(
                  Icons.refresh,
                ),
                label: l10n.exceptionIndicatorTryAgainButton,
              ),
          ],
        ),
      ),
    );
  }
}
