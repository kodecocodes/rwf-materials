import 'sign_in_localizations.dart';

/// The translations for English (`en`).
class SignInLocalizationsEn extends SignInLocalizations {
  SignInLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get invalidCredentialsErrorMessage => 'Invalid email and/or password.';

  @override
  String get appBarTitle => 'Sign In';

  @override
  String get emailTextFieldLabel => 'Email';

  @override
  String get emailTextFieldEmptyErrorMessage => 'Your email can\'t be empty.';

  @override
  String get emailTextFieldInvalidErrorMessage => 'This email is not valid.';

  @override
  String get passwordTextFieldLabel => 'Password';

  @override
  String get passwordTextFieldEmptyErrorMessage =>
      'Your password can\'t be empty.';

  @override
  String get passwordTextFieldInvalidErrorMessage =>
      'Password must be at least five characters long.';

  @override
  String get forgotMyPasswordButtonLabel => 'Forgot my password';

  @override
  String get signInButtonLabel => 'Sign In';

  @override
  String get signUpOpeningText => 'Don\'t have an account?';

  @override
  String get signUpButtonLabel => 'Sign up';
}
