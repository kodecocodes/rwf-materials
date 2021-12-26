import 'forgot_my_password_localizations.dart';

/// The translations for English (`en`).
class ForgotMyPasswordLocalizationsEn extends ForgotMyPasswordLocalizations {
  ForgotMyPasswordLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dialogTitle => 'Forgot My Password';

  @override
  String get emailTextFieldLabel => 'Email';

  @override
  String get emailTextFieldEmptyErrorMessage => 'Your email can\'t be empty.';

  @override
  String get emailTextFieldInvalidErrorMessage => 'This email is not valid.';

  @override
  String get emailRequestSuccessMessage =>
      'If this email is registered in our systems, a link will be sent to you with instructions on how to reset your password.';

  @override
  String get confirmButtonLabel => 'Confirm';

  @override
  String get cancelButtonLabel => 'Cancel';

  @override
  String get errorMessage =>
      'There has been an error. Please, check your internet connection.';
}
