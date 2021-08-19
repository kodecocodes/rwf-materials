part of 'update_profile_bloc.dart';

abstract class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object?> get props => [];
}

class UpdateProfileInProgress extends UpdateProfileState {
  const UpdateProfileInProgress();
}

class UpdateProfileLoaded extends UpdateProfileState {
  const UpdateProfileLoaded({
    required this.username,
    required this.email,
    this.password = const OptionalPassword.pure(),
    this.passwordConfirmation = const OptionalPasswordConfirmation.pure(),
    this.error,
    this.status = FormzStatus.pure,
  });

  final Username username;
  final Email email;
  final OptionalPassword password;
  final OptionalPasswordConfirmation passwordConfirmation;
  final dynamic error;
  final FormzStatus status;

  bool get isSubmissionInProgress => status == FormzStatus.submissionInProgress;

  UpdateProfileLoaded copyWith({
    Username? username,
    Email? email,
    OptionalPassword? password,
    OptionalPasswordConfirmation? passwordConfirmation,
    FormzStatus? status,
    required dynamic error,
  }) {
    return UpdateProfileLoaded(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        username,
        email,
        password,
        passwordConfirmation,
        error,
        status,
      ];
}
