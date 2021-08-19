import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:sign_in/src/l10n/sign_in_localizations.dart';
import 'package:sign_in/src/sign_in_bloc.dart';
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
    return BlocProvider<SignInBloc>(
      create: (_) => SignInBloc(
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
class SignInView extends StatefulWidget {
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
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<SignInBloc>();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        bloc.add(
          const SignInEmailUnfocused(),
        );
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        bloc.add(
          const SignInPasswordUnfocused(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = SignInLocalizations.of(context);
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionSuccess) {
          widget.onSignInSuccess();
          return;
        }

        final error = state.error;
        if (error != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              error is InvalidCredentialsException
                  ? SnackBar(
                      content: Text(
                        l10n.invalidCredentialsErrorMessage,
                      ),
                    )
                  : const GenericErrorSnackBar(),
            );
        }
      },
      child: GestureDetector(
        onTap: () => _releaseFocus(context),
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            backwardsCompatibility: false,
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
                emailFocusNode: _emailFocusNode,
                passwordFocusNode: _passwordFocusNode,
                onSignUpTap: widget.onSignUpTap,
                onForgotMyPasswordTap: widget.onForgotMyPasswordTap,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm({
    required this.emailFocusNode,
    required this.passwordFocusNode,
    this.onSignUpTap,
    this.onForgotMyPasswordTap,
    Key? key,
  }) : super(key: key);

  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final VoidCallback? onSignUpTap;
  final VoidCallback? onForgotMyPasswordTap;

  @override
  Widget build(BuildContext context) {
    final l10n = SignInLocalizations.of(context);
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        final emailError = state.email.invalid ? state.email.error : null;
        final passwordError =
            state.password.invalid ? state.password.error : null;
        final isSubmissionInProgress =
            state.status == FormzStatus.submissionInProgress;

        final bloc = context.read<SignInBloc>();
        return Column(
          children: <Widget>[
            TextField(
              focusNode: emailFocusNode,
              onChanged: (value) {
                bloc.add(
                  SignInEmailChanged(value),
                );
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: const Icon(
                  Icons.alternate_email,
                ),
                enabled: !isSubmissionInProgress,
                labelText: l10n.emailTextFieldLabel,
                errorText: emailError == null
                    ? null
                    : (emailError == EmailValidationError.empty
                        ? l10n.emailTextFieldEmptyErrorMessage
                        : l10n.emailTextFieldInvalidErrorMessage),
              ),
            ),
            const SizedBox(
              height: Spacing.large,
            ),
            TextField(
              focusNode: passwordFocusNode,
              onChanged: (value) {
                bloc.add(
                  SignInPasswordChanged(value),
                );
              },
              obscureText: true,
              onEditingComplete: () {
                bloc.add(
                  const SignInSubmitted(),
                );
              },
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
              onPressed: isSubmissionInProgress ? null : onForgotMyPasswordTap,
            ),
            const SizedBox(
              height: Spacing.small,
            ),
            isSubmissionInProgress
                ? ExpandedElevatedButton.inProgress(
                    label: l10n.signInButtonLabel,
                  )
                : ExpandedElevatedButton(
                    onTap: () {
                      bloc.add(
                        const SignInSubmitted(),
                      );
                    },
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
              onPressed: isSubmissionInProgress ? null : onSignUpTap,
            ),
          ],
        );
      },
    );
  }
}
