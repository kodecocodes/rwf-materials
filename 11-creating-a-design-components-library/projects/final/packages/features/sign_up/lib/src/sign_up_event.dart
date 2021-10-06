part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpUsernameChanged extends SignUpEvent {
  const SignUpUsernameChanged(
    this.username,
  );

  final String username;

  @override
  List<Object> get props => [
        username,
      ];
}

class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged(
    this.email,
  );

  final String email;

  @override
  List<Object> get props => [
        email,
      ];
}

class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged(
    this.password,
  );

  final String password;

  @override
  List<Object> get props => [
        password,
      ];
}

class SignUpPasswordConfirmationChanged extends SignUpEvent {
  const SignUpPasswordConfirmationChanged(
    this.passwordConfirmation,
  );

  final String passwordConfirmation;

  @override
  List<Object> get props => [
        passwordConfirmation,
      ];
}

class SignUpEmailUnfocused extends SignUpEvent {
  const SignUpEmailUnfocused();
}

class SignUpUsernameUnfocused extends SignUpEvent {
  const SignUpUsernameUnfocused();
}

class SignUpPasswordUnfocused extends SignUpEvent {
  const SignUpPasswordUnfocused();
}

class SignUpPasswordConfirmationUnfocused extends SignUpEvent {
  const SignUpPasswordConfirmationUnfocused();
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}
