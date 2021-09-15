part of 'update_profile_bloc.dart';

abstract class UpdateProfileEvent extends Equatable {
  const UpdateProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileStarted extends UpdateProfileEvent {
  const UpdateProfileStarted();
}

class UpdateProfileUsernameChanged extends UpdateProfileEvent {
  const UpdateProfileUsernameChanged(
    this.username,
  );

  final String username;

  @override
  List<Object> get props => [
        username,
      ];
}

class UpdateProfileEmailChanged extends UpdateProfileEvent {
  const UpdateProfileEmailChanged(
    this.email,
  );

  final String email;

  @override
  List<Object> get props => [
        email,
      ];
}

class UpdateProfilePasswordChanged extends UpdateProfileEvent {
  const UpdateProfilePasswordChanged(
    this.password,
  );

  final String password;

  @override
  List<Object> get props => [
        password,
      ];
}

class UpdateProfilePasswordConfirmationChanged extends UpdateProfileEvent {
  const UpdateProfilePasswordConfirmationChanged(
    this.passwordConfirmation,
  );

  final String passwordConfirmation;

  @override
  List<Object> get props => [
        passwordConfirmation,
      ];
}

class UpdateProfileEmailUnfocused extends UpdateProfileEvent {
  const UpdateProfileEmailUnfocused();
}

class UpdateProfileUsernameUnfocused extends UpdateProfileEvent {
  const UpdateProfileUsernameUnfocused();
}

class UpdateProfilePasswordUnfocused extends UpdateProfileEvent {
  const UpdateProfilePasswordUnfocused();
}

class UpdateProfilePasswordConfirmationUnfocused extends UpdateProfileEvent {
  const UpdateProfilePasswordConfirmationUnfocused();
}

class UpdateProfileSubmitted extends UpdateProfileEvent {
  const UpdateProfileSubmitted();
}
