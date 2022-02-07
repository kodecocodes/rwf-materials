part of 'sign_in_cubit.dart';

class SignInState extends Equatable {
  const SignInState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.error,
    this.status = FormzStatus.pure,
  });

  final Email email;
  final Password password;
  final dynamic error;
  final FormzStatus status;

  SignInState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    required dynamic error,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        error,
        status,
      ];
}
