import 'package:bloc_test/bloc_test.dart';
import 'package:form_fields/form_fields.dart';
import 'package:mockito/mockito.dart';
import 'package:sign_in/src/sign_in_cubit.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  blocTest<SignInCubit, SignInState>(
    'Emits SignInState with unvalidated email when email is changed for the first time',
    build: () => SignInCubit(userRepository: MockUserRepository()),
    act: (cubit) => cubit.onEmailChanged('email@gmail.com'),
    expect: () => const <SignInState>[
      SignInState(
          email: Email.unvalidated(
        'email@gmail.com',
      ))
    ],
  );
}
