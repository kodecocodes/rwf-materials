part of 'update_profile_cubit.dart';

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
    required this.email,
    required this.username,
    this.password = const OptionalPassword.unvalidated(),
    this.passwordConfirmation =
        const OptionalPasswordConfirmation.unvalidated(),
    this.submissionStatus = SubmissionStatus.idle,
  });

  final Email email;
  final Username username;
  final OptionalPassword password;
  final OptionalPasswordConfirmation passwordConfirmation;
  final SubmissionStatus submissionStatus;

  bool get isSubmissionInProgress =>
      submissionStatus == SubmissionStatus.inProgress;

  UpdateProfileLoaded copyWith({
    Email? email,
    Username? username,
    OptionalPassword? password,
    OptionalPasswordConfirmation? passwordConfirmation,
    SubmissionStatus? submissionStatus,
  }) {
    return UpdateProfileLoaded(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object?> get props => [
        email,
        username,
        password,
        passwordConfirmation,
        submissionStatus,
      ];
}

enum SubmissionStatus {
  idle,
  inProgress,
  success,
  error,
}
