import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

part 'forgot_my_password_state.dart';

class ForgotMyPasswordCubit extends Cubit<ForgotMyPasswordState> {
  ForgotMyPasswordCubit({
    required this.userRepository,
  }) : super(
          const ForgotMyPasswordState(),
        );

  final UserRepository userRepository;

  void onEmailChanged(String newValue) {
    final previousValue = state.email;
    final shouldValidate = previousValue.invalid;
    final newState = state.copyWith(
      email: shouldValidate
          ? Email.validated(
              newValue,
              isAlreadyRegistered: newValue == previousValue.value
                  ? previousValue.isAlreadyRegistered
                  : false,
            )
          : Email.unvalidated(
              newValue,
            ),
    );

    emit(newState);
  }

  void onEmailUnfocused() {
    final newState = state.copyWith(
      email: Email.validated(
        state.email.value,
      ),
    );
    emit(newState);
  }

  void onSubmit() async {
    final email = Email.validated(state.email.value);
    final newState = state.copyWith(
      email: email,
      submissionStatus: email.valid ? SubmissionStatus.inProgress : null,
    );
    emit(newState);
    if (email.valid) {
      try {
        await userRepository.requestPasswordResetEmail(
          email.value,
        );
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.success,
        );
        emit(newState);
      } catch (_) {
        final newState = state.copyWith(
          submissionStatus: SubmissionStatus.error,
        );
        emit(newState);
      }
    }
  }
}
