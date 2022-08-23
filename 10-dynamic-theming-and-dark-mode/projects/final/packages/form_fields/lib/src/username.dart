import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class Username extends FormzInput<String, UsernameValidationError>
    with EquatableMixin {
  const Username.unvalidated([
    String value = '',
  ])  : isAlreadyRegistered = false,
        super.pure(value);

  const Username.validated(
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
  List<Object?> get props => [
        value,
        pure,
        isAlreadyRegistered,
      ];
}

enum UsernameValidationError {
  empty,
  invalid,
  alreadyTaken,
}
