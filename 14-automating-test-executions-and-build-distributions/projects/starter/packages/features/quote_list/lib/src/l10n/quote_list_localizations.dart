
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'quote_list_localizations_en.dart';
import 'quote_list_localizations_pt.dart';

/// Callers can lookup localized strings with an instance of QuoteListLocalizations returned
/// by `QuoteListLocalizations.of(context)`.
///
/// Applications need to include `QuoteListLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'l10n/quote_list_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: QuoteListLocalizations.localizationsDelegates,
///   supportedLocales: QuoteListLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the QuoteListLocalizations.supportedLocales
/// property.
abstract class QuoteListLocalizations {
  QuoteListLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static QuoteListLocalizations of(BuildContext context) {
    return Localizations.of<QuoteListLocalizations>(context, QuoteListLocalizations)!;
  }

  static const LocalizationsDelegate<QuoteListLocalizations> delegate = _QuoteListLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @quoteListRefreshErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t refresh your items.\nPlease, check your internet connection and try again later.'**
  String get quoteListRefreshErrorMessage;

  /// No description provided for @favoritesTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTagLabel;

  /// No description provided for @lifeTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get lifeTagLabel;

  /// No description provided for @happinessTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Happiness'**
  String get happinessTagLabel;

  /// No description provided for @workTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get workTagLabel;

  /// No description provided for @natureTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get natureTagLabel;

  /// No description provided for @scienceTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get scienceTagLabel;

  /// No description provided for @loveTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get loveTagLabel;

  /// No description provided for @funnyTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Funny'**
  String get funnyTagLabel;
}

class _QuoteListLocalizationsDelegate extends LocalizationsDelegate<QuoteListLocalizations> {
  const _QuoteListLocalizationsDelegate();

  @override
  Future<QuoteListLocalizations> load(Locale locale) {
    return SynchronousFuture<QuoteListLocalizations>(lookupQuoteListLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_QuoteListLocalizationsDelegate old) => false;
}

QuoteListLocalizations lookupQuoteListLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return QuoteListLocalizationsEn();
    case 'pt': return QuoteListLocalizationsPt();
  }

  throw FlutterError(
    'QuoteListLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
