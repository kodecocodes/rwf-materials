import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:update_profile/src/l10n/update_profile_localizations.dart';
import 'package:update_profile/src/update_profile_cubit.dart';
import 'package:user_repository/user_repository.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({
    required this.userRepository,
    required this.onUpdateProfileSuccess,
    Key? key,
  }) : super(key: key);

  final UserRepository userRepository;
  final VoidCallback onUpdateProfileSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProfileCubit>(
      create: (_) => UpdateProfileCubit(
        userRepository: userRepository,
      ),
      child: UpdateProfileView(
        onUpdateProfileSuccess: onUpdateProfileSuccess,
      ),
    );
  }
}

@visibleForTesting
class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({
    required this.onUpdateProfileSuccess,
    Key? key,
  }) : super(key: key);

  final VoidCallback onUpdateProfileSuccess;

  @override
  _UpdateProfileViewState createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordConfirmationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        final cubit = context.read<UpdateProfileCubit>();
        cubit.onUsernameUnfocused();
      }
    });
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        final cubit = context.read<UpdateProfileCubit>();
        cubit.onEmailUnfocused();
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        final cubit = context.read<UpdateProfileCubit>();
        cubit.onPasswordUnfocused();
      }
    });
    _passwordConfirmationFocusNode.addListener(() {
      if (!_passwordConfirmationFocusNode.hasFocus) {
        final bloc = context.read<UpdateProfileCubit>();
        bloc.onPasswordConfirmationUnfocused();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileCubit, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileLoaded) {
          if (state.status == FormzStatus.submissionSuccess) {
            widget.onUpdateProfileSuccess();
            return;
          }

          if (state.error != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const GenericErrorSnackBar(),
              );
          }
        }
      },
      child: GestureDetector(
        onTap: () => _releaseFocus(context),
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: Text(
              UpdateProfileLocalizations.of(context).appBarTitle,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: Spacing.mediumLarge,
              right: Spacing.mediumLarge,
              top: Spacing.mediumLarge,
            ),
            child: _UpdateProfileForm(
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

class _UpdateProfileForm extends StatelessWidget {
  const _UpdateProfileForm({
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
    return BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
      builder: (context, state) {
        final l10n = UpdateProfileLocalizations.of(context);
        if (state is UpdateProfileLoaded) {
          final usernameError =
              state.username.invalid ? state.username.error : null;
          final emailError = state.email.invalid ? state.email.error : null;
          final passwordError =
              state.password.invalid ? state.password.error : null;
          final passwordConfirmationError = state.passwordConfirmation.invalid
              ? state.passwordConfirmation.error
              : null;
          final cubit = context.read<UpdateProfileCubit>();
          return Column(
            children: <Widget>[
              TextFormField(
                focusNode: usernameFocusNode,
                initialValue: state.username.value,
                onChanged: cubit.onUsernameChanged,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.person,
                  ),
                  enabled: !state.isSubmissionInProgress,
                  labelText: l10n.usernameTextFieldLabel,
                  errorText: usernameError == null
                      ? null
                      : (usernameError == UsernameValidationError.empty
                          ? l10n.usernameTextFieldEmptyErrorMessage
                          : (usernameError ==
                                  UsernameValidationError.alreadyTaken
                              ? l10n.usernameTextFieldAlreadyTakenErrorMessage
                              : l10n.usernameTextFieldInvalidErrorMessage)),
                ),
              ),
              const SizedBox(
                height: Spacing.mediumLarge,
              ),
              TextFormField(
                focusNode: emailFocusNode,
                initialValue: state.email.value,
                onChanged: cubit.onEmailChanged,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.alternate_email,
                  ),
                  enabled: !state.isSubmissionInProgress,
                  labelText: l10n.emailTextFieldLabel,
                  errorText: emailError == null
                      ? null
                      : (emailError == EmailValidationError.empty
                          ? l10n.emailTextFieldEmptyErrorMessage
                          : (emailError ==
                                  EmailValidationError.alreadyRegistered
                              ? l10n.emailTextFieldAlreadyRegisteredErrorMessage
                              : l10n.emailTextFieldInvalidErrorMessage)),
                ),
              ),
              const SizedBox(
                height: Spacing.mediumLarge,
              ),
              TextField(
                focusNode: passwordFocusNode,
                onChanged: cubit.onPasswordChanged,
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.password,
                  ),
                  enabled: !state.isSubmissionInProgress,
                  labelText: l10n.passwordTextFieldLabel,
                  errorText: passwordError == null
                      ? null
                      : l10n.passwordTextFieldInvalidErrorMessage,
                ),
              ),
              const SizedBox(
                height: Spacing.mediumLarge,
              ),
              TextField(
                focusNode: passwordConfirmationFocusNode,
                onChanged: cubit.onPasswordConfirmationChanged,
                onEditingComplete: cubit.onSubmit,
                obscureText: true,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.password,
                  ),
                  enabled: !state.isSubmissionInProgress,
                  labelText: l10n.passwordConfirmationTextFieldLabel,
                  errorText: passwordConfirmationError == null
                      ? null
                      : l10n.passwordConfirmationTextFieldInvalidErrorMessage,
                ),
              ),
              const SizedBox(
                height: Spacing.xxxLarge,
              ),
              state.isSubmissionInProgress
                  ? ExpandedElevatedButton.inProgress(
                      label: l10n.updateProfileButtonLabel,
                    )
                  : ExpandedElevatedButton(
                      onTap: cubit.onSubmit,
                      label: l10n.updateProfileButtonLabel,
                      icon: const Icon(
                        Icons.login,
                      ),
                    ),
            ],
          );
        } else {
          // TODO: replace with centered circular progress indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
