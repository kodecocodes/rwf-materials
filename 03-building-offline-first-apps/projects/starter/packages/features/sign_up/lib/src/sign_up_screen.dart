import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:sign_up/src/l10n/sign_up_localizations.dart';
import 'package:sign_up/src/sign_up_bloc.dart';
import 'package:user_repository/user_repository.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
    required this.userRepository,
    required this.onSignUpSuccess,
    Key? key,
  }) : super(key: key);

  final UserRepository userRepository;
  final VoidCallback onSignUpSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (_) => SignUpBloc(
        userRepository: userRepository,
      ),
      child: SignUpView(
        onSignUpSuccess: onSignUpSuccess,
      ),
    );
  }
}

@visibleForTesting
class SignUpView extends StatefulWidget {
  const SignUpView({
    required this.onSignUpSuccess,
    Key? key,
  }) : super(key: key);

  final VoidCallback onSignUpSuccess;

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordConfirmationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        final bloc = context.read<SignUpBloc>();
        bloc.add(
          const SignUpUsernameUnfocused(),
        );
      }
    });
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        final bloc = context.read<SignUpBloc>();
        bloc.add(
          const SignUpEmailUnfocused(),
        );
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        final bloc = context.read<SignUpBloc>();
        bloc.add(
          const SignUpPasswordUnfocused(),
        );
      }
    });
    _passwordConfirmationFocusNode.addListener(() {
      if (!_passwordConfirmationFocusNode.hasFocus) {
        final bloc = context.read<SignUpBloc>();
        bloc.add(
          const SignUpPasswordConfirmationUnfocused(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionSuccess) {
          widget.onSignUpSuccess();
          return;
        }

        if (state.error != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const GenericErrorSnackBar(),
            );
        }
      },
      child: GestureDetector(
        onTap: () => _releaseFocus(context),
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: Text(
              SignUpLocalizations.of(context).appBarTitle,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: Spacing.mediumLarge,
              right: Spacing.mediumLarge,
              top: Spacing.mediumLarge,
            ),
            child: _SignUpForm(
              usernameFocusNode: _usernameFocusNode,
              emailFocusNode: _emailFocusNode,
              passwordFocusNode: _passwordFocusNode,
              passwordConfirmationFocusNode: _passwordConfirmationFocusNode,
            ),
          ),
        ),
      ),
    );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();
}

class _SignUpForm extends StatelessWidget {
  const _SignUpForm({
    required this.usernameFocusNode,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.passwordConfirmationFocusNode,
    Key? key,
  }) : super(key: key);

  final FocusNode usernameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode passwordConfirmationFocusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        final l10n = SignUpLocalizations.of(context);
        final bloc = context.read<SignUpBloc>();
        final usernameError =
            state.username.invalid ? state.username.error : null;
        final emailError = state.email.invalid ? state.email.error : null;
        final passwordError =
            state.password.invalid ? state.password.error : null;
        final passwordConfirmationError = state.passwordConfirmation.invalid
            ? state.passwordConfirmation.error
            : null;
        final isSubmissionInProgress =
            state.status == FormzStatus.submissionInProgress;
        return Column(
          children: <Widget>[
            TextField(
              focusNode: usernameFocusNode,
              onChanged: (value) {
                bloc.add(
                  SignUpUsernameChanged(value),
                );
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                suffixIcon: const Icon(
                  Icons.person,
                ),
                enabled: !isSubmissionInProgress,
                labelText: l10n.usernameTextFieldLabel,
                errorText: usernameError == null
                    ? null
                    : (usernameError == UsernameValidationError.empty
                        ? l10n.usernameTextFieldEmptyErrorMessage
                        : (usernameError == UsernameValidationError.alreadyTaken
                            ? l10n.usernameTextFieldAlreadyTakenErrorMessage
                            : l10n.usernameTextFieldInvalidErrorMessage)),
              ),
            ),
            const SizedBox(
              height: Spacing.mediumLarge,
            ),
            TextField(
              focusNode: emailFocusNode,
              onChanged: (value) {
                bloc.add(
                  SignUpEmailChanged(value),
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
                        : (emailError == EmailValidationError.alreadyRegistered
                            ? l10n.emailTextFieldAlreadyRegisteredErrorMessage
                            : l10n.emailTextFieldInvalidErrorMessage)),
              ),
            ),
            const SizedBox(
              height: Spacing.mediumLarge,
            ),
            TextField(
              focusNode: passwordFocusNode,
              onChanged: (value) {
                bloc.add(
                  SignUpPasswordChanged(value),
                );
              },
              textInputAction: TextInputAction.next,
              obscureText: true,
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
            const SizedBox(
              height: Spacing.mediumLarge,
            ),
            TextField(
              focusNode: passwordConfirmationFocusNode,
              onChanged: (value) {
                bloc.add(
                  SignUpPasswordConfirmationChanged(value),
                );
              },
              onEditingComplete: () {
                bloc.add(
                  const SignUpSubmitted(),
                );
              },
              obscureText: true,
              decoration: InputDecoration(
                suffixIcon: const Icon(
                  Icons.password,
                ),
                enabled: !isSubmissionInProgress,
                labelText: l10n.passwordConfirmationTextFieldLabel,
                errorText: passwordConfirmationError == null
                    ? null
                    : (passwordConfirmationError ==
                            PasswordConfirmationValidationError.empty
                        ? l10n.passwordConfirmationTextFieldEmptyErrorMessage
                        : l10n
                            .passwordConfirmationTextFieldInvalidErrorMessage),
              ),
            ),
            const SizedBox(
              height: Spacing.xxxLarge,
            ),
            isSubmissionInProgress
                ? ExpandedElevatedButton.inProgress(
                    label: l10n.signUpButtonLabel,
                  )
                : ExpandedElevatedButton(
                    onTap: () {
                      bloc.add(
                        const SignUpSubmitted(),
                      );
                    },
                    label: l10n.signUpButtonLabel,
                    icon: const Icon(
                      Icons.login,
                    ),
                  ),
          ],
        );
      },
    );
  }
}
