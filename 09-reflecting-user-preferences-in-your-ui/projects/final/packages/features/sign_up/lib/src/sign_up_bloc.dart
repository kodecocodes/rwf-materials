import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required this.userRepository,
  }) : super(
          const SignUpState(),
        );

  final UserRepository userRepository;

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpUsernameChanged) {
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
    } else if (event is SignUpEmailChanged) {
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
    } else if (event is SignUpPasswordChanged) {
      final previousValue = state.password;
      final shouldValidate = previousValue.invalid;
      yield state.copyWith(
        password: shouldValidate
            ? Password.dirty(
                event.password,
              )
            : Password.pure(
                event.password,
              ),
        error: null,
      );
    } else if (event is SignUpPasswordConfirmationChanged) {
      final previousValue = state.passwordConfirmation;
      final shouldValidate = previousValue.invalid;
      yield state.copyWith(
        passwordConfirmation: shouldValidate
            ? PasswordConfirmation.dirty(
                event.passwordConfirmation,
                password: state.password,
              )
            : PasswordConfirmation.pure(
                event.passwordConfirmation,
              ),
        error: null,
      );
    } else if (event is SignUpUsernameUnfocused) {
      yield state.copyWith(
        username: Username.dirty(
          state.username.value,
          isAlreadyTaken: state.username.isAlreadyTaken,
        ),
        error: null,
      );
    } else if (event is SignUpEmailUnfocused) {
      yield state.copyWith(
        email: Email.dirty(
          state.email.value,
          isAlreadyRegistered: state.email.isAlreadyRegistered,
        ),
        error: null,
      );
    } else if (event is SignUpPasswordUnfocused) {
      yield state.copyWith(
        password: Password.dirty(
          state.password.value,
        ),
        error: null,
      );
    } else if (event is SignUpPasswordConfirmationUnfocused) {
      yield state.copyWith(
        passwordConfirmation: PasswordConfirmation.dirty(
          state.passwordConfirmation.value,
          password: state.password,
        ),
        error: null,
      );
    } else if (event is SignUpSubmitted) {
      final username = Username.dirty(
        state.username.value,
        isAlreadyTaken: state.username.isAlreadyTaken,
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
          await userRepository.signUp(
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
  }
}
