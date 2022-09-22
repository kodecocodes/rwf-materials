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
class UpdateProfileView extends StatelessWidget {
  const UpdateProfileView({
    required this.onUpdateProfileSuccess,
    Key? key,
  }) : super(key: key);

  final VoidCallback onUpdateProfileSuccess;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            onUpdateProfileSuccess: onUpdateProfileSuccess,
          ),
        ),
      ),
    );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();
}

class _UpdateProfileForm extends StatefulWidget {
  const _UpdateProfileForm({
    required this.onUpdateProfileSuccess,
    Key? key,
  }) : super(key: key);

  final VoidCallback onUpdateProfileSuccess;

  @override
  State<_UpdateProfileForm> createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<_UpdateProfileForm> {
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
    return BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
      listenWhen: (oldState, newState) =>
          (oldState is UpdateProfileLoaded
              ? oldState.submissionStatus
              : null) !=
          (newState is UpdateProfileLoaded ? newState.submissionStatus : null),
      listener: (context, state) {
        if (state is UpdateProfileLoaded) {
          if (state.submissionStatus == SubmissionStatus.success) {
            widget.onUpdateProfileSuccess();
            return;
          }

          if (state.submissionStatus == SubmissionStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const GenericErrorSnackBar(),
              );
          }
        }
      },
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
                focusNode: _usernameFocusNode,
                initialValue: state.username.value,
                onChanged: cubit.onUsernameChanged,
                textInputAction: TextInputAction.next,
                autocorrect: false,
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
                focusNode: _emailFocusNode,
                initialValue: state.email.value,
                onChanged: cubit.onEmailChanged,
                textInputAction: TextInputAction.next,
                autocorrect: false,
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
                focusNode: _passwordFocusNode,
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
                focusNode: _passwordConfirmationFocusNode,
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
          return const CenteredCircularProgressIndicator();
        }
      },
    );
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationFocusNode.dispose();
    super.dispose();
  }
}
