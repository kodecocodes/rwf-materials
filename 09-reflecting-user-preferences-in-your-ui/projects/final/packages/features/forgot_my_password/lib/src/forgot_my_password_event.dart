part of 'forgot_my_password_bloc.dart';

abstract class ForgotMyPasswordEvent extends Equatable {
  const ForgotMyPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgotMyPasswordEmailChanged extends ForgotMyPasswordEvent {
  const ForgotMyPasswordEmailChanged(
    this.email,
  );

  final String email;

  @override
  List<Object> get props => [email];
}

class ForgotMyPasswordEmailUnfocused extends ForgotMyPasswordEvent {
  const ForgotMyPasswordEmailUnfocused();
}

class ForgotMyPasswordEmailSubmitted extends ForgotMyPasswordEvent {
  const ForgotMyPasswordEmailSubmitted();
}
