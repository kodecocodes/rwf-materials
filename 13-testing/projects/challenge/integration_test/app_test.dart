import 'package:component_library/component_library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:wonder_words/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('search for life quotes', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 1));

    final searchBarFinder = find.byType(SearchBar);

    expect(searchBarFinder, findsOneWidget);

    await tester.enterText(searchBarFinder, 'life');

    await tester.pumpAndSettle();

    expect(find.byType(QuoteCard), findsWidgets);
  });
}
