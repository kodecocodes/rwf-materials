part of 'forgot_my_password_bloc.dart';

class ForgotMyPasswordState extends Equatable {
  const ForgotMyPasswordState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
  });

  final Email email;
  final FormzStatus status;

  ForgotMyPasswordState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
  }) {
    return ForgotMyPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        email,
        status,
      ];
}
