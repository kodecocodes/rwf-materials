import 'forgot_my_password_localizations.dart';

/// The translations for Portuguese (`pt`).
class ForgotMyPasswordLocalizationsPt extends ForgotMyPasswordLocalizations {
  ForgotMyPasswordLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get dialogTitle => 'Esqueci Minha Senha';

  @override
  String get emailTextFieldLabel => 'Email';

  @override
  String get emailTextFieldEmptyErrorMessage => 'Seu email não pode ser vazio.';

  @override
  String get emailTextFieldInvalidErrorMessage => 'Este email não é válido.';

  @override
  String get emailRequestSuccessMessage =>
      'Se este email estiver registrado em nossos servidores, um link será enviado para você com instruções sobre como resetar sua senha.';

  @override
  String get confirmButtonLabel => 'Confirmar';

  @override
  String get cancelButtonLabel => 'Cancelar';

  @override
  String get errorMessage =>
      'Ocorreu um erro. Por favor, confira sua conexão com a internet.';
}
