import 'package:equatable/equatable.dart';
import 'package:form_fields/form_fields.dart';

class PasswordConfirmation
    extends FormzInput<String, PasswordConfirmationValidationError>
    with EquatableMixin {
  const PasswordConfirmation.unvalidated([
    String value = '',
  ])  : password = const Password.unvalidated(),
        super.pure(value);

  const PasswordConfirmation.validated(
    String value, {
    required this.password,
  }) : super.dirty(value);

  final Password password;

  @override
  PasswordConfirmationValidationError? validator(String value) {
    return value.isEmpty
        ? PasswordConfirmationValidationError.empty
        : (value == password.value
            ? null
            : PasswordConfirmationValidationError.invalid);
  }

  @override
  List<Object?> get props => [
        value,
        pure,
        password,
      ];
}

enum PasswordConfirmationValidationError {
  empty,
  invalid,
}
