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
          ? Username.validated(
              newValue,
              isAlreadyRegistered: newValue == previousValue.value
                  ? previousValue.isAlreadyRegistered
                  : false,
            )
          : Username.unvalidated(
              newValue,
            ),
    );

    emit(newState);
  }

  void onEmailChanged(String newValue) {
    final currentState = state as UpdateProfileLoaded;
    final previousValue = currentState.email;
    final shouldValidate = previousValue.invalid;
    final newState = currentState.copyWith(
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

  void onPasswordChanged(String newValue) {
    final currentState = state as UpdateProfileLoaded;
    final previousValue = currentState.password;
    final shouldValidate = previousValue.invalid && newValue.isNotEmpty;
    final newState = currentState.copyWith(
      password: shouldValidate
          ? OptionalPassword.validated(
              newValue,
            )
          : OptionalPassword.unvalidated(
              newValue,
            ),
    );
    emit(newState);
  }

  void onPasswordConfirmationChanged(String newValue) {
    final currentState = state as UpdateProfileLoaded;
    final previousValue = currentState.passwordConfirmation;
    final shouldValidate = previousValue.invalid;
    final newState = currentState.copyWith(
      passwordConfirmation: shouldValidate
          ? OptionalPasswordConfirmation.validated(
              newValue,
              password: currentState.password,
            )
          : OptionalPasswordConfirmation.unvalidated(
              newValue,
            ),
    );
    emit(newState);
  }

  void onUsernameUnfocused() {
    final currentState = state as UpdateProfileLoaded;
    final newState = currentState.copyWith(
      username: Username.validated(
        currentState.username.value,
        isAlreadyRegistered: currentState.username.isAlreadyRegistered,
      ),
    );
    emit(newState);
  }

  void onEmailUnfocused() {
    final currentState = state as UpdateProfileLoaded;
    final newState = currentState.copyWith(
      email: Email.validated(
        currentState.email.value,
        isAlreadyRegistered: currentState.email.isAlreadyRegistered,
      ),
    );
    emit(newState);
  }

  void onPasswordUnfocused() {
    final currentState = state as UpdateProfileLoaded;
    final newState = currentState.copyWith(
      password: OptionalPassword.validated(
        currentState.password.value,
      ),
    );
    emit(newState);
  }

  void onPasswordConfirmationUnfocused() {
    final currentState = state as UpdateProfileLoaded;
    final confirmation = OptionalPasswordConfirmation.validated(
      currentState.passwordConfirmation.value,
      password: currentState.password,
    );
    final newState = currentState.copyWith(
      passwordConfirmation: confirmation,
    );
    emit(newState);
  }

  void onSubmit() async {
    final currentState = state as UpdateProfileLoaded;
    final username = Username.validated(
      currentState.username.value,
      isAlreadyRegistered: currentState.username.isAlreadyRegistered,
    );
    final email = Email.validated(
      currentState.email.value,
      isAlreadyRegistered: currentState.email.isAlreadyRegistered,
    );
    final password = OptionalPassword.validated(
      currentState.password.value,
    );
    final passwordConfirmation = OptionalPasswordConfirmation.validated(
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
      submissionStatus: isFormValid ? SubmissionStatus.inProgress : null,
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
          submissionStatus: SubmissionStatus.success,
        );
        emit(newState);
      } catch (error) {
        final newState = currentState.copyWith(
          submissionStatus: error is! UsernameAlreadyTakenException &&
                  error is! EmailAlreadyRegisteredException
              ? SubmissionStatus.error
              : SubmissionStatus.idle,
          username: error is UsernameAlreadyTakenException
              ? Username.validated(
                  username.value,
                  isAlreadyRegistered: true,
                )
              : null,
          email: error is EmailAlreadyRegisteredException
              ? Email.validated(
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
        username: Username.unvalidated(user.username),
        email: Email.unvalidated(user.email),
      );
      emit(newState);
    }
  }
}
