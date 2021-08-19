import 'package:formz/formz.dart';

enum UsernameValidationError {
  empty,
  invalid,
  alreadyTaken,
}

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure([String value = ''])
      : isAlreadyTaken = false,
        super.pure(value);

  const Username.dirty(
    String value, {
    this.isAlreadyTaken = false,
  }) : super.dirty(value);

  static final _usernameRegex = RegExp(
    r'^(?=.{1,20}$)(?![_])(?!.*[_.]{2})[a-zA-Z0-9_]+(?<![_])$',
  );

  final bool isAlreadyTaken;

  @override
  UsernameValidationError? validator(String value) {
    return value.isEmpty
        ? UsernameValidationError.empty
        : (isAlreadyTaken
            ? UsernameValidationError.alreadyTaken
            : (_usernameRegex.hasMatch(value)
                ? null
                : UsernameValidationError.invalid));
  }

  @override
  int get hashCode => value.hashCode ^ pure.hashCode ^ isAlreadyTaken.hashCode;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is Username &&
        other.value == value &&
        other.pure == pure &&
        other.isAlreadyTaken == isAlreadyTaken;
  }
}
