import 'package:formz/formz.dart';

enum EmailValidationError {
  empty,
  invalid,
  alreadyRegistered,
}

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure([String value = ''])
      : isAlreadyRegistered = false,
        super.pure(value);

  const Email.dirty(
    String value, {
    this.isAlreadyRegistered = false,
  }) : super.dirty(value);

  static final _emailRegex = RegExp(
    '^(([\\w-]+\\.)+[\\w-]+|([a-zA-Z]|[\\w-]{2,}))@((([0-1]?'
    '[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.'
    '([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])\\.([0-1]?[0-9]{1,2}|25[0-5]|2[0-4][0-9])'
    ')|([a-zA-Z]+[\\w-]+\\.)+[a-zA-Z]{2,4})\$',
  );
  final bool isAlreadyRegistered;

  @override
  EmailValidationError? validator(String value) {
    return value.isEmpty
        ? EmailValidationError.empty
        : (isAlreadyRegistered
            ? EmailValidationError.alreadyRegistered
            : (_emailRegex.hasMatch(value)
                ? null
                : EmailValidationError.invalid));
  }

  @override
  int get hashCode =>
      value.hashCode ^ pure.hashCode ^ isAlreadyRegistered.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is Email &&
        other.value == value &&
        other.pure == pure &&
        other.isAlreadyRegistered == isAlreadyRegistered;
  }
}
