import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

part 'update_profile_event.dart';

part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  UpdateProfileBloc({
    required this.userRepository,
  }) : super(
          const UpdateProfileInProgress(),
        ) {
    add(
      const UpdateProfileStarted(),
    );
  }

  final UserRepository userRepository;

  @override
  Stream<UpdateProfileState> mapEventToState(UpdateProfileEvent event) async* {
    final state = this.state;
    if (state is UpdateProfileLoaded) {
      if (event is UpdateProfileUsernameChanged) {
        final previousValue = state.email;
        final shouldValidate = previousValue.invalid;
        yield state.copyWith(
          username: shouldValidate
              ? Username.dirty(
                  event.username,
                  isAlreadyTaken: event.username == previousValue.value
                      ? previousValue.isAlreadyRegistered
                      : false,
                )
              : Username.pure(
                  event.username,
                ),
          error: null,
        );
      } else if (event is UpdateProfileEmailChanged) {
        final previousValue = state.email;
        final shouldValidate = previousValue.invalid;
        yield state.copyWith(
          email: shouldValidate
              ? Email.dirty(
                  event.email,
                  isAlreadyRegistered: event.email == previousValue.value
                      ? previousValue.isAlreadyRegistered
                      : false,
                )
              : Email.pure(
                  event.email,
                ),
          error: null,
        );
      } else if (event is UpdateProfilePasswordChanged) {
        final previousValue = state.password;
        final shouldValidate =
            previousValue.invalid && event.password.isNotEmpty;
        yield state.copyWith(
          password: shouldValidate
              ? OptionalPassword.dirty(
                  event.password,
                )
              : OptionalPassword.pure(
                  event.password,
                ),
          error: null,
        );
      } else if (event is UpdateProfilePasswordConfirmationChanged) {
        final previousValue = state.passwordConfirmation;
        final shouldValidate = previousValue.invalid;
        yield state.copyWith(
          passwordConfirmation: shouldValidate
              ? OptionalPasswordConfirmation.dirty(
                  event.passwordConfirmation,
                  password: state.password,
                )
              : OptionalPasswordConfirmation.pure(
                  event.passwordConfirmation,
                ),
          error: null,
        );
      } else if (event is UpdateProfileUsernameUnfocused) {
        yield state.copyWith(
          username: Username.dirty(
            state.username.value,
            isAlreadyTaken: state.username.isAlreadyTaken,
          ),
          error: null,
        );
      } else if (event is UpdateProfileEmailUnfocused) {
        yield state.copyWith(
          email: Email.dirty(
            state.email.value,
            isAlreadyRegistered: state.email.isAlreadyRegistered,
          ),
          error: null,
        );
      } else if (event is UpdateProfilePasswordUnfocused) {
        yield state.copyWith(
          password: OptionalPassword.dirty(
            state.password.value,
          ),
          error: null,
        );
      } else if (event is UpdateProfilePasswordConfirmationUnfocused) {
        final confirmation = OptionalPasswordConfirmation.dirty(
          state.passwordConfirmation.value,
          password: state.password,
        );
        yield state.copyWith(
          passwordConfirmation: confirmation,
          error: null,
        );
      } else if (event is UpdateProfileSubmitted) {
        final username = Username.dirty(
          state.username.value,
          isAlreadyTaken: state.username.isAlreadyTaken,
        );
        final email = Email.dirty(
          state.email.value,
          isAlreadyRegistered: state.email.isAlreadyRegistered,
        );
        final password = OptionalPassword.dirty(
          state.password.value,
        );
        final passwordConfirmation = OptionalPasswordConfirmation.dirty(
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
        yield state.copyWith(
          username: username,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
          status: isFormValid ? FormzStatus.submissionInProgress : state.status,
          error: null,
        );

        if (isFormValid) {
          try {
            await userRepository.updateProfile(
              username.value,
              email.value,
              password.value,
            );
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
              error: null,
            );
          } catch (error) {
            yield state.copyWith(
              error: error is! UsernameAlreadyTakenException &&
                  error is! EmailAlreadyRegisteredException
                  ? error
                  : null,
              status: FormzStatus.submissionFailure,
              username: error is UsernameAlreadyTakenException
                  ? Username.dirty(
                      username.value,
                      isAlreadyTaken: true,
                    )
                  : null,
              email: error is EmailAlreadyRegisteredException
                  ? Email.dirty(
                      email.value,
                      isAlreadyRegistered: true,
                    )
                  : null,
            );
          }
        }
      }
    } else {
      final user = await userRepository.getUser().first;
      if (user != null) {
        yield UpdateProfileLoaded(
          username: Username.pure(user.username),
          email: Email.pure(user.email),
        );
      }
    }
  }
}
