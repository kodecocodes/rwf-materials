import 'package:formz/formz.dart';

enum UsernameValidationError {
  empty,
  invalid,
  alreadyTaken,
}

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure([String value = ''])
      : isAlreadyRegistered = false,
        super.pure(value);

  const Username.dirty(
    String value, {
    this.isAlreadyRegistered = false,
  }) : super.dirty(value);

  static final _usernameRegex = RegExp(
    r'^(?=.{1,20}$)(?![_])(?!.*[_.]{2})[a-zA-Z0-9_]+(?<![_])$',
  );

  final bool isAlreadyRegistered;

  @override
  UsernameValidationError? validator(String value) {
    return value.isEmpty
        ? UsernameValidationError.empty
        : (isAlreadyRegistered
            ? UsernameValidationError.alreadyTaken
            : (_usernameRegex.hasMatch(value)
                ? null
                : UsernameValidationError.invalid));
  }

  @override
  int get hashCode =>
      value.hashCode ^ pure.hashCode ^ isAlreadyRegistered.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is Username &&
        other.value == value &&
        other.pure == pure &&
        other.isAlreadyRegistered == isAlreadyRegistered;
  }
}
