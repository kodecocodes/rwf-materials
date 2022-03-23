import 'package:formz/formz.dart';

enum OptionalPasswordValidationError {
  invalid,
}

class OptionalPassword
    extends FormzInput<String, OptionalPasswordValidationError> {
  const OptionalPassword.pure([String value = '']) : super.pure(value);

  const OptionalPassword.dirty([String value = '']) : super.dirty(value);

  @override
  OptionalPasswordValidationError? validator(String value) {
    return value.isEmpty
        ? null
        : (value.length >= 5 && value.length <= 120
            ? null
            : OptionalPasswordValidationError.invalid);
  }
}
