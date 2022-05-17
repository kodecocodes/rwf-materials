import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:sign_in/src/l10n/sign_in_localizations.dart';
import 'package:sign_in/src/sign_in_cubit.dart';
import 'package:user_repository/user_repository.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({
    required this.userRepository,
    required this.onSignInSuccess,
    this.onForgotMyPasswordTap,
    this.onSignUpTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onSignUpTap;
  final VoidCallback? onForgotMyPasswordTap;
  final VoidCallback onSignInSuccess;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInCubit>(
      create: (_) => SignInCubit(
        userRepository: userRepository,
      ),
      child: SignInView(
        onSignUpTap: onSignUpTap,
        onSignInSuccess: onSignInSuccess,
        onForgotMyPasswordTap: onForgotMyPasswordTap,
      ),
    );
  }
}

@visibleForTesting
class SignInView extends StatelessWidget {
  const SignInView({
    required this.onSignInSuccess,
    this.onSignUpTap,
    this.onForgotMyPasswordTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onSignUpTap;
  final VoidCallback? onForgotMyPasswordTap;
  final VoidCallback onSignInSuccess;

  @override
  Widget build(BuildContext context) {
    final l10n = SignInLocalizations.of(context);
    return GestureDetector(
      onTap: () => _releaseFocus(context),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Text(
            l10n.appBarTitle,
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.mediumLarge,
            ),
            child: _SignInForm(
              onSignUpTap: onSignUpTap,
              onForgotMyPasswordTap: onForgotMyPasswordTap,
              onSignInSuccess: onSignInSuccess,
            ),
          ),
        ),
      ),
    );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();
}

class _SignInForm extends StatefulWidget {
  const _SignInForm({
    required this.onSignInSuccess,
    this.onSignUpTap,
    this.onForgotMyPasswordTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onSignUpTap;
  final VoidCallback? onForgotMyPasswordTap;
  final VoidCallback onSignInSuccess;

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final _passwordFocusNode = FocusNode();

  // TODO: Add _emailFocusNode.

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SignInCubit>();
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        cubit.onPasswordUnfocused();
      }
    });

    // TODO: Add a listener to _emailFocusNode.
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    // TODO: Dispose _emailFocusNode.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = SignInLocalizations.of(context);
    return BlocConsumer<SignInCubit, SignInState>(
      listenWhen: (oldState, newState) =>
          oldState.submissionStatus != newState.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus == SubmissionStatus.success) {
          widget.onSignInSuccess();
          return;
        }

        final hasSubmissionError = state.submissionStatus ==
                SubmissionStatus.genericError ||
            state.submissionStatus == SubmissionStatus.invalidCredentialsError;

        if (hasSubmissionError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              state.submissionStatus == SubmissionStatus.invalidCredentialsError
                  ? SnackBar(
                      content: Text(
                        l10n.invalidCredentialsErrorMessage,
                      ),
                    )
                  : const GenericErrorSnackBar(),
            );
        }
      },
      builder: (context, state) {
        // TODO: Check for errors in the email state.

        final passwordError =
            state.password.invalid ? state.password.error : null;

        final isSubmissionInProgress =
            state.submissionStatus == SubmissionStatus.inProgress;

        final cubit = context.read<SignInCubit>();
        return Column(
          children: <Widget>[
            TextField(
              // TODO: Attach the _emailFocusNode.
              // TODO: Forward email change events to the Cubit.
              textInputAction: TextInputAction.next,
              autocorrect: false,
              decoration: InputDecoration(
                suffixIcon: const Icon(
                  Icons.alternate_email,
                ),
                enabled: !isSubmissionInProgress,
                labelText: l10n.emailTextFieldLabel,
                // TODO: Display the email validation error if any.
              ),
            ),
            const SizedBox(
              height: Spacing.large,
            ),
            TextField(
              focusNode: _passwordFocusNode,
              onChanged: cubit.onPasswordChanged,
              obscureText: true,
              onEditingComplete: cubit.onSubmit,
              decoration: InputDecoration(
                suffixIcon: const Icon(
                  Icons.password,
                ),
                enabled: !isSubmissionInProgress,
                labelText: l10n.passwordTextFieldLabel,
                errorText: passwordError == null
                    ? null
                    : (passwordError == PasswordValidationError.empty
                        ? l10n.passwordTextFieldEmptyErrorMessage
                        : l10n.passwordTextFieldInvalidErrorMessage),
              ),
            ),
            TextButton(
              child: Text(
                l10n.forgotMyPasswordButtonLabel,
              ),
              onPressed:
                  isSubmissionInProgress ? null : widget.onForgotMyPasswordTap,
            ),
            const SizedBox(
              height: Spacing.small,
            ),
            isSubmissionInProgress
                ? ExpandedElevatedButton.inProgress(
                    label: l10n.signInButtonLabel,
                  )
                : ExpandedElevatedButton(
                    onTap: cubit.onSubmit,
                    label: l10n.signInButtonLabel,
                    icon: const Icon(
                      Icons.login,
                    ),
                  ),
            const SizedBox(
              height: Spacing.xxLarge,
            ),
            Text(
              l10n.signUpOpeningText,
            ),
            TextButton(
              child: Text(
                l10n.signUpButtonLabel,
              ),
              onPressed: isSubmissionInProgress ? null : widget.onSignUpTap,
            ),
          ],
        );
      },
    );
  }
}
