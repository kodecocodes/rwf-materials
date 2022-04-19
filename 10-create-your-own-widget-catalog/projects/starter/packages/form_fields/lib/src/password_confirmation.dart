import 'package:form_fields/form_fields.dart';

enum PasswordConfirmationValidationError {
  empty,
  invalid,
}

class PasswordConfirmation
    extends FormzInput<String, PasswordConfirmationValidationError> {
  const PasswordConfirmation.pure([String value = ''])
      : password = const Password.pure(),
        super.pure(value);

  const PasswordConfirmation.dirty(
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
  int get hashCode => value.hashCode ^ pure.hashCode ^ password.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is PasswordConfirmation &&
        other.value == value &&
        other.pure == pure &&
        other.password == password;
  }
}
