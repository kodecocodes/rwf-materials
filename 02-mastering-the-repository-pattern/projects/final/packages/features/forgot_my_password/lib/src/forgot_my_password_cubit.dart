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
          ? Email.dirty(
              newValue,
              isAlreadyRegistered: newValue == previousValue.value
                  ? previousValue.isAlreadyRegistered
                  : false,
            )
          : Email.pure(
              newValue,
            ),
    );

    emit(newState);
  }

  void onEmailUnfocused() {
    final newState = state.copyWith(
      email: Email.dirty(
        state.email.value,
      ),
    );
    emit(newState);
  }

  void onSubmit() async {
    final email = Email.dirty(state.email.value);
    final newState = state.copyWith(
      email: email,
      status: email.valid ? FormzStatus.submissionInProgress : state.status,
    );
    emit(newState);
    if (email.valid) {
      try {
        await userRepository.requestPasswordResetEmail(
          email.value,
        );
        final newState = state.copyWith(
          status: FormzStatus.submissionSuccess,
        );
        emit(newState);
      } catch (error) {
        final newState = state.copyWith(
          status: FormzStatus.submissionFailure,
        );
        emit(newState);
      }
    }
  }
}
