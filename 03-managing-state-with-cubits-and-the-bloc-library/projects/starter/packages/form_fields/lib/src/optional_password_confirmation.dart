import 'package:form_fields/form_fields.dart';

enum OptionalPasswordConfirmationValidationError {
  empty,
  invalid,
}

class OptionalPasswordConfirmation
    extends FormzInput<String, OptionalPasswordConfirmationValidationError> {
  const OptionalPasswordConfirmation.pure([String value = ''])
      : password = const OptionalPassword.pure(),
        super.pure(value);

  const OptionalPasswordConfirmation.dirty(
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
  int get hashCode => value.hashCode ^ pure.hashCode ^ password.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is OptionalPasswordConfirmation &&
        other.value == value &&
        other.pure == pure &&
        other.password == password;
  }
}
