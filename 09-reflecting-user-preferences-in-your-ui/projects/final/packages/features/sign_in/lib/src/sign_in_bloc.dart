import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({
    required this.userRepository,
  }) : super(
          const SignInState(),
        );

  final UserRepository userRepository;

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is SignInEmailChanged) {
      final previousValue = state.email;
      final shouldValidate = previousValue.invalid;
      yield state.copyWith(
        email: shouldValidate
            ? Email.dirty(
                event.email,
              )
            : Email.pure(
                event.email,
              ),
        error: null,
      );
    } else if (event is SignInPasswordChanged) {
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
    } else if (event is SignInEmailUnfocused) {
      yield state.copyWith(
        email: Email.dirty(
          state.email.value,
        ),
        error: null,
      );
    } else if (event is SignInPasswordUnfocused) {
      yield state.copyWith(
        password: Password.dirty(
          state.password.value,
        ),
        error: null,
      );
    } else if (event is SignInSubmitted) {
      final email = Email.dirty(state.email.value);
      final password = Password.dirty(state.password.value);
      final isFormValid = Formz.validate([
            email,
            password,
          ]) ==
          FormzStatus.valid;
      yield state.copyWith(
        email: email,
        password: password,
        status: isFormValid ? FormzStatus.submissionInProgress : state.status,
        error: null,
      );
      if (isFormValid) {
        try {
          await userRepository.signIn(
            email.value,
            password.value,
          );
          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
            error: null,
          );
        } catch (error) {
          yield state.copyWith(
            error: error,
            status: FormzStatus.submissionFailure,
          );
        }
      }
    }
  }
}
