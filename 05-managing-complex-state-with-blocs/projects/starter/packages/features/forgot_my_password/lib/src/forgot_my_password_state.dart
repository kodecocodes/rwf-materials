part of 'forgot_my_password_cubit.dart';

class ForgotMyPasswordState extends Equatable {
  const ForgotMyPasswordState({
    this.email = const Email.unvalidated(),
    this.submissionStatus,
  });

  final Email email;
  final SubmissionStatus? submissionStatus;

  ForgotMyPasswordState copyWith({
    Email? email,
    Password? password,
    SubmissionStatus? submissionStatus,
  }) {
    return ForgotMyPasswordState(
      email: email ?? this.email,
      submissionStatus: submissionStatus,
    );
  }

  @override
  List<Object?> get props => [
        email,
        submissionStatus,
      ];
}

enum SubmissionStatus {
  inProgress,
  success,
  error,
}
