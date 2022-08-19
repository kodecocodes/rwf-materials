import 'sign_in_localizations.dart';

/// The translations for Portuguese (`pt`).
class SignInLocalizationsPt extends SignInLocalizations {
  SignInLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get invalidCredentialsErrorMessage => 'Email e/ou senha inválida.';

  @override
  String get appBarTitle => 'Entrar';

  @override
  String get emailTextFieldLabel => 'Email';

  @override
  String get emailTextFieldEmptyErrorMessage => 'Seu email não pode ser vazio.';

  @override
  String get emailTextFieldInvalidErrorMessage => 'Esse email não é válido.';

  @override
  String get passwordTextFieldLabel => 'Senha';

  @override
  String get passwordTextFieldEmptyErrorMessage =>
      'Sua senha não pode ser vazia.';

  @override
  String get passwordTextFieldInvalidErrorMessage =>
      'Sua senha precisa ter pelo menos cinco caracteres.';

  @override
  String get forgotMyPasswordButtonLabel => 'Esqueci minha senha';

  @override
  String get signInButtonLabel => 'Entrar';

  @override
  String get signUpOpeningText => 'Não tem uma conta?';

  @override
  String get signUpButtonLabel => 'Cadastrar';
}
