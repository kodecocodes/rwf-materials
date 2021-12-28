import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required this.userRepository,
  }) : super(
          const SignUpState(),
        );

  final UserRepository userRepository;

  void onUsernameChanged(String newValue) {
    final previousUsername = state.username;
    final shouldValidate = previousUsername.invalid;
    final newState = state.copyWith(
      username: shouldValidate
          ? Username.dirty(
              newValue,
              isAlreadyRegistered: newValue == previousUsername.value
                  ? previousUsername.isAlreadyRegistered
                  : false,
            )
          : Username.pure(
              newValue,
            ),
    );
    emit(newState);
  }

  void onEmailChanged(String newValue) {
    final previousEmail = state.email;
    final shouldValidate = previousEmail.invalid;
    final newState = state.copyWith(
      email: shouldValidate
          ? Email.dirty(
              newValue,
              isAlreadyRegistered: newValue == previousEmail.value
                  ? previousEmail.isAlreadyRegistered
                  : false,
            )
          : Email.pure(
              newValue,
            ),
    );
    emit(newState);
  }

  void onPasswordChanged(String newValue) {
    final previousPassword = state.password;
    final shouldValidate = previousPassword.invalid;
    final newState = state.copyWith(
      password: shouldValidate
          ? Password.dirty(
              newValue,
            )
          : Password.pure(
              newValue,
            ),
    );

    emit(newState);
  }

  void onPasswordConfirmationChanged(String newValue) {
    final previousPasswordConfirmation = state.passwordConfirmation;
    final shouldValidate = previousPasswordConfirmation.invalid;
    final newState = state.copyWith(
      passwordConfirmation: shouldValidate
          ? PasswordConfirmation.dirty(
              newValue,
              password: state.password,
            )
          : PasswordConfirmation.pure(
              newValue,
            ),
    );
    emit(newState);
  }

  void onUsernameUnfocused() {
    final newState = state.copyWith(
      username: Username.dirty(
        state.username.value,
        isAlreadyRegistered: state.username.isAlreadyRegistered,
      ),
    );

    emit(newState);
  }

  void onEmailUnfocused() {
    final newState = state.copyWith(
      email: Email.dirty(
        state.email.value,
        isAlreadyRegistered: state.email.isAlreadyRegistered,
      ),
    );

    emit(newState);
  }

  void onPasswordUnfocused() {
    final newState = state.copyWith(
      password: Password.dirty(
        state.password.value,
      ),
    );
    emit(newState);
  }

  void onPasswordConfirmationUnfocused() {
    final newState = state.copyWith(
      passwordConfirmation: PasswordConfirmation.dirty(
        state.passwordConfirmation.value,
        password: state.password,
      ),
    );
    emit(newState);
  }

  void onSubmit() async {
    final username = Username.dirty(
      state.username.value,
      isAlreadyRegistered: state.username.isAlreadyRegistered,
    );

    final email = Email.dirty(
      state.email.value,
      isAlreadyRegistered: state.email.isAlreadyRegistered,
    );

    final password = Password.dirty(
      state.password.value,
    );

    final passwordConfirmation = PasswordConfirmation.dirty(
      state.passwordConfirmation.value,
      password: password,
    );

    final isFormValid = Formz.validate([
          username,
          email,
          password,
          passwordConfirmation,
        ]) ==
        FormzStatus.valid;

    final newState = state.copyWith(
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      status: isFormValid ? FormzStatus.submissionInProgress : state.status,
    );

    emit(newState);

    if (isFormValid) {
      try {
        await userRepository.signUp(
          username.value,
          email.value,
          password.value,
        );
        final newState = state.copyWith(
          status: FormzStatus.submissionSuccess,
        );
        emit(newState);
      } catch (error) {
        final newState = state.copyWith(
          status: FormzStatus.submissionFailure,
          username: error is UsernameAlreadyTakenException
              ? Username.dirty(
                  username.value,
                  isAlreadyRegistered: true,
                )
              : null,
          email: error is EmailAlreadyRegisteredException
              ? Email.dirty(
                  email.value,
                  isAlreadyRegistered: true,
                )
              : null,
        );

        emit(newState);
      }
    }
  }
}
