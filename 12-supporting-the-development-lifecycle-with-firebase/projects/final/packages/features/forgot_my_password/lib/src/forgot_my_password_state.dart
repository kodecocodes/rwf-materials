part of 'forgot_my_password_cubit.dart';

class ForgotMyPasswordState extends Equatable {
  const ForgotMyPasswordState({
    this.email = const Email.unvalidated(),
    this.submissionStatus = SubmissionStatus.idle,
  });

  final Email email;
  final SubmissionStatus submissionStatus;

  ForgotMyPasswordState copyWith({
    Email? email,
    Password? password,
    SubmissionStatus? submissionStatus,
  }) {
    return ForgotMyPasswordState(
      email: email ?? this.email,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object?> get props => [
        email,
        submissionStatus,
      ];
}

enum SubmissionStatus {
  idle,
  inProgress,
  success,
  error,
}
