import 'quote_details_localizations.dart';

/// The translations for English (`en`).
class QuoteDetailsLocalizationsEn extends QuoteDetailsLocalizations {
  QuoteDetailsLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String shareQuoteText(String link) {
    return 'Hey, take a look at this quote I just found on Wonder Words: $link';
  }
}
