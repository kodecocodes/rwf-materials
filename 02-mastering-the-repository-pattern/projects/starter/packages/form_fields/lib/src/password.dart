import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  invalid,
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure([String value = '']) : super.pure(value);

  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String value) {
    return value.isEmpty
        ? PasswordValidationError.empty
        : (value.length >= 5 && value.length <= 120
            ? null
            : PasswordValidationError.invalid);
  }
}
