import 'update_profile_localizations.dart';

/// The translations for English (`en`).
class UpdateProfileLocalizationsEn extends UpdateProfileLocalizations {
  UpdateProfileLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appBarTitle => 'Update Profile';

  @override
  String get updateProfileButtonLabel => 'Update';

  @override
  String get usernameTextFieldLabel => 'Username';

  @override
  String get usernameTextFieldEmptyErrorMessage =>
      'Your username can\'t be empty.';

  @override
  String get usernameTextFieldInvalidErrorMessage =>
      'Your username must be 1-20 characters long and can only contain letters, numbers, and the underscore (_).';

  @override
  String get usernameTextFieldAlreadyTakenErrorMessage =>
      'This username is already taken.';

  @override
  String get emailTextFieldLabel => 'Email';

  @override
  String get emailTextFieldEmptyErrorMessage => 'Your email can\'t be empty.';

  @override
  String get emailTextFieldInvalidErrorMessage => 'This email is not valid.';

  @override
  String get emailTextFieldAlreadyRegisteredErrorMessage =>
      'This email is already registered.';

  @override
  String get passwordTextFieldLabel => 'New Password';

  @override
  String get passwordTextFieldInvalidErrorMessage =>
      'Password must be at least five characters long.';

  @override
  String get passwordConfirmationTextFieldLabel => 'New Password Confirmation';

  @override
  String get passwordConfirmationTextFieldInvalidErrorMessage =>
      'Your passwords don\'t match.';
}
