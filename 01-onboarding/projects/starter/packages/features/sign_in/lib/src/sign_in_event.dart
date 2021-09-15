part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => [];
}

class SignInEmailChanged extends SignInEvent {
  const SignInEmailChanged(
    this.email,
  );

  final String email;

  @override
  List<Object> get props => [email];
}

class SignInPasswordChanged extends SignInEvent {
  const SignInPasswordChanged(
    this.password,
  );

  final String password;

  @override
  List<Object> get props => [password];
}

class SignInEmailUnfocused extends SignInEvent {
  const SignInEmailUnfocused();
}

class SignInPasswordUnfocused extends SignInEvent {
  const SignInPasswordUnfocused();
}

class SignInSubmitted extends SignInEvent {
  const SignInSubmitted();
}
