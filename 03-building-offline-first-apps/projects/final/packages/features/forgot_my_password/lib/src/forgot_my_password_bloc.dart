import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

part 'forgot_my_password_event.dart';
part 'forgot_my_password_state.dart';

class ForgotMyPasswordBloc
    extends Bloc<ForgotMyPasswordEvent, ForgotMyPasswordState> {
  ForgotMyPasswordBloc({
    required this.userRepository,
  }) : super(
          const ForgotMyPasswordState(),
        );

  final UserRepository userRepository;

  @override
  Stream<ForgotMyPasswordState> mapEventToState(
    ForgotMyPasswordEvent event,
  ) async* {
    if (event is ForgotMyPasswordEmailChanged) {
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
      );
    } else if (event is ForgotMyPasswordEmailUnfocused) {
      yield state.copyWith(
        email: Email.dirty(
          state.email.value,
        ),
      );
    } else if (event is ForgotMyPasswordEmailSubmitted) {
      final email = Email.dirty(state.email.value);
      yield state.copyWith(
        email: email,
        status: email.valid ? FormzStatus.submissionInProgress : state.status,
      );
      if (email.valid) {
        try {
          await userRepository.requestPasswordResetEmail(
            email.value,
          );
          yield state.copyWith(
            status: FormzStatus.submissionSuccess,
          );
        } catch (error) {
          yield state.copyWith(
            status: FormzStatus.submissionFailure,
          );
        }
      }
    }
  }
}
