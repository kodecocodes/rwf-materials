import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit({
    required this.userRepository,
  }) : super(
          const UpdateProfileInProgress(),
        ) {
    _fetchUser();
  }

  final UserRepository userRepository;

  void onUsernameChanged(String newValue) {
    final currentState = state as UpdateProfileLoaded;
    final previousValue = currentState.email;
    final shouldValidate = previousValue.invalid;
    final newState = currentState.copyWith(
      username: shouldValidate
          ? Username.dirty(
              newValue,
              isAlreadyRegistered: newValue == previousValue.value
                  ? previousValue.isAlreadyRegistered
                  : false,
            )
          : Username.pure(
              newValue,
            ),
      error: null,
    );

    emit(newState);
  }

  void onEmailChanged(String newValue) {
    final currentState = state as UpdateProfileLoaded;
    final previousValue = currentState.email;
    final shouldValidate = previousValue.invalid;
    final newState = currentState.copyWith(
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
      error: null,
    );
    emit(newState);
  }

  void onPasswordChanged(String newValue) {
    final currentState = state as UpdateProfileLoaded;
    final previousValue = currentState.password;
    final shouldValidate = previousValue.invalid && newValue.isNotEmpty;
    final newState = currentState.copyWith(
      password: shouldValidate
          ? OptionalPassword.dirty(
              newValue,
            )
          : OptionalPassword.pure(
              newValue,
            ),
      error: null,
    );
    emit(newState);
  }

  void onPasswordConfirmationChanged(String newValue) {
    final currentState = state as UpdateProfileLoaded;
    final previousValue = currentState.passwordConfirmation;
    final shouldValidate = previousValue.invalid;
    final newState = currentState.copyWith(
      passwordConfirmation: shouldValidate
          ? OptionalPasswordConfirmation.dirty(
              newValue,
              password: currentState.password,
            )
          : OptionalPasswordConfirmation.pure(
              newValue,
            ),
      error: null,
    );
    emit(newState);
  }

  void onUsernameUnfocused() {
    final currentState = state as UpdateProfileLoaded;
    final newState = currentState.copyWith(
      username: Username.dirty(
        currentState.username.value,
        isAlreadyRegistered: currentState.username.isAlreadyRegistered,
      ),
      error: null,
    );
    emit(newState);
  }

  void onEmailUnfocused() {
    final currentState = state as UpdateProfileLoaded;
    final newState = currentState.copyWith(
      email: Email.dirty(
        currentState.email.value,
        isAlreadyRegistered: currentState.email.isAlreadyRegistered,
      ),
      error: null,
    );
    emit(newState);
  }

  void onPasswordUnfocused() {
    final currentState = state as UpdateProfileLoaded;
    final newState = currentState.copyWith(
      password: OptionalPassword.dirty(
        currentState.password.value,
      ),
      error: null,
    );
    emit(newState);
  }

  void onPasswordConfirmationUnfocused() {
    final currentState = state as UpdateProfileLoaded;
    final confirmation = OptionalPasswordConfirmation.dirty(
      currentState.passwordConfirmation.value,
      password: currentState.password,
    );
    final newState = currentState.copyWith(
      passwordConfirmation: confirmation,
      error: null,
    );
    emit(newState);
  }

  void onSubmit() async {
    final currentState = state as UpdateProfileLoaded;
    final username = Username.dirty(
      currentState.username.value,
      isAlreadyRegistered: currentState.username.isAlreadyRegistered,
    );
    final email = Email.dirty(
      currentState.email.value,
      isAlreadyRegistered: currentState.email.isAlreadyRegistered,
    );
    final password = OptionalPassword.dirty(
      currentState.password.value,
    );
    final passwordConfirmation = OptionalPasswordConfirmation.dirty(
      currentState.passwordConfirmation.value,
      password: password,
    );
    final isFormValid = Formz.validate([
          username,
          email,
          password,
          passwordConfirmation,
        ]) ==
        FormzStatus.valid;
    final newState = currentState.copyWith(
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      status:
          isFormValid ? FormzStatus.submissionInProgress : currentState.status,
      error: null,
    );
    emit(newState);

    if (isFormValid) {
      try {
        await userRepository.updateProfile(
          username.value,
          email.value,
          password.value,
        );
        final newState = currentState.copyWith(
          status: FormzStatus.submissionSuccess,
          error: null,
        );
        emit(newState);
      } catch (error) {
        final newState = currentState.copyWith(
          error: error is! UsernameAlreadyTakenException &&
                  error is! EmailAlreadyRegisteredException
              ? error
              : null,
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

  Future<void> _fetchUser() async {
    final user = await userRepository.getUser().first;
    if (user != null) {
      final newState = UpdateProfileLoaded(
        username: Username.pure(user.username),
        email: Email.pure(user.email),
      );
      emit(newState);
    }
  }
}
