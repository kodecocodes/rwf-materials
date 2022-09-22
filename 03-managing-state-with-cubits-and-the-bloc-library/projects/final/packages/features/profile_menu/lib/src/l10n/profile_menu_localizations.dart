import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'profile_menu_localizations_en.dart';
import 'profile_menu_localizations_pt.dart';

/// Callers can lookup localized strings with an instance of ProfileMenuLocalizations returned
/// by `ProfileMenuLocalizations.of(context)`.
///
/// Applications need to include `ProfileMenuLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'l10n/profile_menu_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ProfileMenuLocalizations.localizationsDelegates,
///   supportedLocales: ProfileMenuLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the ProfileMenuLocalizations.supportedLocales
/// property.
abstract class ProfileMenuLocalizations {
  ProfileMenuLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ProfileMenuLocalizations of(BuildContext context) {
    return Localizations.of<ProfileMenuLocalizations>(
        context, ProfileMenuLocalizations)!;
  }

  static const LocalizationsDelegate<ProfileMenuLocalizations> delegate =
      _ProfileMenuLocalizationsDelegate();

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

  /// No description provided for @signInButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButtonLabel;

  /// No description provided for @signedInUserGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {username}!'**
  String signedInUserGreeting(String username);

  /// No description provided for @updateProfileTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfileTileLabel;

  /// No description provided for @darkModePreferencesHeaderTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode Preferences'**
  String get darkModePreferencesHeaderTileLabel;

  /// No description provided for @darkModePreferencesAlwaysDarkTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Always Dark'**
  String get darkModePreferencesAlwaysDarkTileLabel;

  /// No description provided for @darkModePreferencesAlwaysLightTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Always Light'**
  String get darkModePreferencesAlwaysLightTileLabel;

  /// No description provided for @darkModePreferencesUseSystemSettingsTileLabel.
  ///
  /// In en, this message translates to:
  /// **'Use System Settings'**
  String get darkModePreferencesUseSystemSettingsTileLabel;

  /// No description provided for @signOutButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutButtonLabel;

  /// No description provided for @signUpOpeningText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get signUpOpeningText;

  /// No description provided for @signUpButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpButtonLabel;
}

class _ProfileMenuLocalizationsDelegate
    extends LocalizationsDelegate<ProfileMenuLocalizations> {
  const _ProfileMenuLocalizationsDelegate();

  @override
  Future<ProfileMenuLocalizations> load(Locale locale) {
    return SynchronousFuture<ProfileMenuLocalizations>(
        lookupProfileMenuLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_ProfileMenuLocalizationsDelegate old) => false;
}

ProfileMenuLocalizations lookupProfileMenuLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ProfileMenuLocalizationsEn();
    case 'pt':
      return ProfileMenuLocalizationsPt();
  }

  throw FlutterError(
      'ProfileMenuLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
