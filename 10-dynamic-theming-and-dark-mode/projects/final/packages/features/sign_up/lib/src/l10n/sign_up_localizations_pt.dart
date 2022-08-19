import 'sign_up_localizations.dart';

/// The translations for Portuguese (`pt`).
class SignUpLocalizationsPt extends SignUpLocalizations {
  SignUpLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get invalidCredentialsErrorMessage => 'Email e/ou senha inválida.';

  @override
  String get appBarTitle => 'Cadastro';

  @override
  String get signUpButtonLabel => 'Cadastrar';

  @override
  String get usernameTextFieldLabel => 'Usuário';

  @override
  String get usernameTextFieldEmptyErrorMessage =>
      'Seu usuário não pode ser vazio.';

  @override
  String get usernameTextFieldInvalidErrorMessage =>
      'Seu usuário precisa ter entre 1 e 20 caracteres e pode conter apenas letras, números, e underline (_).';

  @override
  String get usernameTextFieldAlreadyTakenErrorMessage =>
      'Esse usuário já está cadastrado.';

  @override
  String get emailTextFieldLabel => 'Email';

  @override
  String get emailTextFieldEmptyErrorMessage => 'Seu email não pode ser vazio.';

  @override
  String get emailTextFieldInvalidErrorMessage => 'Esse email não é válido.';

  @override
  String get emailTextFieldAlreadyRegisteredErrorMessage =>
      'Esse email já está cadastrado.';

  @override
  String get passwordTextFieldLabel => 'Senha';

  @override
  String get passwordTextFieldEmptyErrorMessage =>
      'Sua senha não pode ser vazia.';

  @override
  String get passwordTextFieldInvalidErrorMessage =>
      'Sua senha precisa ter pelo menos cinco caracteres.';

  @override
  String get passwordConfirmationTextFieldLabel => 'Confirmação de Senha';

  @override
  String get passwordConfirmationTextFieldEmptyErrorMessage =>
      'Não pode ser vazia.';

  @override
  String get passwordConfirmationTextFieldInvalidErrorMessage =>
      'Suas senhas precisam ser iguais.';
}
