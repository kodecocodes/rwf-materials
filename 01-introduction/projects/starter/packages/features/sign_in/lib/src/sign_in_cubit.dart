import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({
    required this.userRepository,
  }) : super(
          const SignInState(),
        );

  final UserRepository userRepository;

  void onEmailChanged(String newValue) {
    final previousValue = state.email;
    final shouldValidate = previousValue.invalid;
    final newState = state.copyWith(
      email: shouldValidate
          ? Email.dirty(
              newValue,
            )
          : Email.pure(
              newValue,
            ),
      error: null,
    );

    emit(newState);
  }

  void onPasswordChanged(String newValue) {
    final previousValue = state.password;
    final shouldValidate = previousValue.invalid;
    final newState = state.copyWith(
      password: shouldValidate
          ? Password.dirty(
              newValue,
            )
          : Password.pure(
              newValue,
            ),
      error: null,
    );

    emit(newState);
  }

  void onEmailUnfocused() {
    final newState = state.copyWith(
      email: Email.dirty(
        state.email.value,
      ),
      error: null,
    );

    emit(newState);
  }

  void onPasswordUnfocused() {
    final newState = state.copyWith(
      password: Password.dirty(
        state.password.value,
      ),
      error: null,
    );

    emit(newState);
  }

  void onSubmit() async {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final isFormValid = Formz.validate([
          email,
          password,
        ]) ==
        FormzStatus.valid;
    final newState = state.copyWith(
      email: email,
      password: password,
      status: isFormValid ? FormzStatus.submissionInProgress : state.status,
      error: null,
    );
    emit(newState);
    if (isFormValid) {
      try {
        await userRepository.signIn(
          email.value,
          password.value,
        );
        final newState = state.copyWith(
          status: FormzStatus.submissionSuccess,
          error: null,
        );
        emit(newState);
      } catch (error) {
        final newState = state.copyWith(
          error: error,
          status: FormzStatus.submissionFailure,
        );
        emit(newState);
      }
    }
  }
}
