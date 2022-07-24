import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:wonder_words/l10n/app_localizations.dart';

class TabContainerScreen extends StatelessWidget {
  const TabContainerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tabState = CupertinoTabPage.of(context);

    return CupertinoTabScaffold(
      controller: tabState.controller,
      tabBuilder: tabState.tabBuilder,
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            label: l10n.quotesBottomNavigationBarItemLabel,
            icon: const Icon(
              Icons.format_quote,
            ),
          ),
          BottomNavigationBarItem(
            label: l10n.profileBottomNavigationBarItemLabel,
            icon: const Icon(
              Icons.person,
            ),
          ),
        ],
      ),
    );
  }
}
