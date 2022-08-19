import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'component_library_localizations_en.dart';
import 'component_library_localizations_pt.dart';

/// Callers can lookup localized strings with an instance of ComponentLibraryLocalizations returned
/// by `ComponentLibraryLocalizations.of(context)`.
///
/// Applications need to include `ComponentLibraryLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'l10n/component_library_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ComponentLibraryLocalizations.localizationsDelegates,
///   supportedLocales: ComponentLibraryLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the ComponentLibraryLocalizations.supportedLocales
/// property.
abstract class ComponentLibraryLocalizations {
  ComponentLibraryLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ComponentLibraryLocalizations of(BuildContext context) {
    return Localizations.of<ComponentLibraryLocalizations>(
        context, ComponentLibraryLocalizations)!;
  }

  static const LocalizationsDelegate<ComponentLibraryLocalizations> delegate =
      _ComponentLibraryLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
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

  /// No description provided for @downvoteIconButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Downvote'**
  String get downvoteIconButtonTooltip;

  /// No description provided for @upvoteIconButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Upvote'**
  String get upvoteIconButtonTooltip;

  /// No description provided for @searchBarHintText.
  ///
  /// In en, this message translates to:
  /// **'journey'**
  String get searchBarHintText;

  /// No description provided for @searchBarLabelText.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchBarLabelText;

  /// No description provided for @shareIconButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareIconButtonTooltip;

  /// No description provided for @favoriteIconButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favoriteIconButtonTooltip;

  /// No description provided for @exceptionIndicatorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get exceptionIndicatorGenericTitle;

  /// No description provided for @exceptionIndicatorTryAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get exceptionIndicatorTryAgainButton;

  /// No description provided for @exceptionIndicatorGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'There has been an error.\nPlease, check your internet connection and try again later.'**
  String get exceptionIndicatorGenericMessage;

  /// No description provided for @genericErrorSnackbarMessage.
  ///
  /// In en, this message translates to:
  /// **'There has been an error. Please, check your internet connection.'**
  String get genericErrorSnackbarMessage;

  /// No description provided for @authenticationRequiredErrorSnackbarMessage.
  ///
  /// In en, this message translates to:
  /// **'You need to sign in before performing this action.'**
  String get authenticationRequiredErrorSnackbarMessage;
}

class _ComponentLibraryLocalizationsDelegate
    extends LocalizationsDelegate<ComponentLibraryLocalizations> {
  const _ComponentLibraryLocalizationsDelegate();

  @override
  Future<ComponentLibraryLocalizations> load(Locale locale) {
    return SynchronousFuture<ComponentLibraryLocalizations>(
        lookupComponentLibraryLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_ComponentLibraryLocalizationsDelegate old) => false;
}

ComponentLibraryLocalizations lookupComponentLibraryLocalizations(
    Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ComponentLibraryLocalizationsEn();
    case 'pt':
      return ComponentLibraryLocalizationsPt();
  }

  throw FlutterError(
      'ComponentLibraryLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
