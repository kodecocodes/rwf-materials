import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forgot_my_password/src/forgot_my_password_cubit.dart';
import 'package:forgot_my_password/src/l10n/forgot_my_password_localizations.dart';
import 'package:form_fields/form_fields.dart';
import 'package:user_repository/user_repository.dart';

class ForgotMyPasswordDialog extends StatelessWidget {
  const ForgotMyPasswordDialog({
    required this.userRepository,
    required this.onCancelTap,
    required this.onEmailRequestSuccess,
    Key? key,
  }) : super(key: key);

  final UserRepository userRepository;
  final VoidCallback onCancelTap;
  final VoidCallback onEmailRequestSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotMyPasswordCubit>(
      create: (_) => ForgotMyPasswordCubit(
        userRepository: userRepository,
      ),
      child: ForgotMyPasswordView(
        onCancelTap: onCancelTap,
        onEmailRequestSuccess: onEmailRequestSuccess,
      ),
    );
  }
}

@visibleForTesting
class ForgotMyPasswordView extends StatefulWidget {
  const ForgotMyPasswordView({
    required this.onCancelTap,
    required this.onEmailRequestSuccess,
    Key? key,
  }) : super(key: key);

  final VoidCallback onCancelTap;
  final VoidCallback onEmailRequestSuccess;

  @override
  _ForgotMyPasswordViewState createState() => _ForgotMyPasswordViewState();
}

class _ForgotMyPasswordViewState extends State<ForgotMyPasswordView> {
  final _emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        final cubit = context.read<ForgotMyPasswordCubit>();
        cubit.onEmailUnfocused();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ForgotMyPasswordLocalizations.of(context);
    return BlocConsumer<ForgotMyPasswordCubit, ForgotMyPasswordState>(
      listener: (context, state) {
        if (state.submissionStatus == SubmissionStatus.success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  l10n.emailRequestSuccessMessage,
                ),
                duration: const Duration(
                  seconds: 8,
                ),
              ),
            );
          widget.onEmailRequestSuccess();
          return;
        }
      },
      builder: (context, state) {
        final cubit = context.read<ForgotMyPasswordCubit>();
        final isSubmissionInProgress =
            state.submissionStatus == SubmissionStatus.inProgress;
        final emailError = state.email.invalid ? state.email.error : null;
        return GestureDetector(
          onTap: () => _releaseFocus(context),
          child: AlertDialog(
            title: Text(l10n.dialogTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  focusNode: _emailFocusNode,
                  enabled: !isSubmissionInProgress,
                  onEditingComplete: cubit.onSubmit,
                  onChanged: cubit.onEmailChanged,
                  autocorrect: false,
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
                if (state.submissionStatus == SubmissionStatus.error) ...[
                  const SizedBox(
                    height: Spacing.medium,
                  ),
                  Text(
                    l10n.errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: FontSize.medium,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: isSubmissionInProgress ? null : widget.onCancelTap,
                child: Text(
                  l10n.cancelButtonLabel,
                ),
              ),
              isSubmissionInProgress
                  ? InProgressTextButton(
                      label: l10n.confirmButtonLabel,
                    )
                  : TextButton(
                      onPressed: cubit.onSubmit,
                      child: Text(
                        l10n.confirmButtonLabel,
                      ),
                    )
            ],
          ),
        );
      },
    );
  }

  void _releaseFocus(BuildContext context) => FocusScope.of(context).unfocus();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }
}
