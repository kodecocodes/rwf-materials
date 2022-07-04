import 'package:equatable/equatable.dart';
import 'package:form_fields/form_fields.dart';

/// Represents an optional password confirmation field.
///
/// Used in conjunction with [OptionalPassword] when the password can or can't
/// be changed, such as in the update profile screen.
class OptionalPasswordConfirmation
    extends FormzInput<String, OptionalPasswordConfirmationValidationError>
    with EquatableMixin {
  const OptionalPasswordConfirmation.unvalidated([
    String value = '',
  ])  : password = const OptionalPassword.unvalidated(),
        super.pure(value);

  const OptionalPasswordConfirmation.validated(
    String value, {
    required this.password,
  }) : super.dirty(value);

  final OptionalPassword password;

  @override
  OptionalPasswordConfirmationValidationError? validator(String value) {
    return value.isEmpty
        ? (password.value.isEmpty
            ? null
            : OptionalPasswordConfirmationValidationError.empty)
        : (value == password.value
            ? null
            : OptionalPasswordConfirmationValidationError.invalid);
  }

  @override
  List<Object?> get props => [
        value,
        pure,
        password,
      ];
}

enum OptionalPasswordConfirmationValidationError {
  empty,
  invalid,
}
