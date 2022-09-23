import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FavoriteIconButton tests: ', () {
    testWidgets('onTap() callback is executed when tapping on button',
        (tester) async {
      bool value = false;

      await tester.pumpWidget(MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [ComponentLibraryLocalizations.delegate],
        home: Scaffold(
          body: FavoriteIconButton(
              isFavorite: false,
              onTap: () {
                value = !value;
              }),
        ),
      ));

      await tester.tap(find.byType(FavoriteIconButton));

      expect(value, true);
    });
  });
}
