import 'update_profile_localizations.dart';

/// The translations for Portuguese (`pt`).
class UpdateProfileLocalizationsPt extends UpdateProfileLocalizations {
  UpdateProfileLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appBarTitle => 'Atualizar Perfil';

  @override
  String get updateProfileButtonLabel => 'Atualizar';

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
      'Este usuário já está cadastrado.';

  @override
  String get emailTextFieldLabel => 'Email';

  @override
  String get emailTextFieldEmptyErrorMessage => 'Seu email não pode ser vazio.';

  @override
  String get emailTextFieldInvalidErrorMessage => 'Este email não é válido.';

  @override
  String get emailTextFieldAlreadyRegisteredErrorMessage =>
      'Este email já está cadastrado.';

  @override
  String get passwordTextFieldLabel => 'Nova Senha';

  @override
  String get passwordTextFieldInvalidErrorMessage =>
      'Sua senha precisa ter pelo menos cinco caracteres.';

  @override
  String get passwordConfirmationTextFieldLabel => 'Confirmação da Nova Senha';

  @override
  String get passwordConfirmationTextFieldInvalidErrorMessage =>
      'Suas senhas precisam ser iguais.';
}
