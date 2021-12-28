part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.username = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.passwordConfirmation = const PasswordConfirmation.pure(),
    this.status = FormzStatus.pure,
  });

  final Username username;
  final Email email;
  final Password password;
  final PasswordConfirmation passwordConfirmation;
  final FormzStatus status;

  SignUpState copyWith({
    Username? username,
    Email? email,
    Password? password,
    PasswordConfirmation? passwordConfirmation,
    FormzStatus? status,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        username,
        email,
        password,
        passwordConfirmation,
        status,
      ];
}
