import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/exceptions/exceptions.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/notifiers/auth/auth_notifiers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dialogs/dialog_utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isEmailSent = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEmailSent ? 'Set New Password' : 'Reset Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isEmailSent) ...[
                Text(
                  'Enter your email address to receive a password reset link',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                PrimaryTextField(
                  label: 'Email',
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
                    }
                    if (!value!.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Send Reset Link',
                  onPressed: _handleSendResetLink,
                ),
              ] else ...[
                Text(
                  'Enter your new password',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                PrimaryTextField(
                  label: 'New Password',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline,
                  isObscure: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter new password';
                    }
                    if (value!.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                PrimaryTextField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  prefixIcon: Icons.lock_outline,
                  isObscure: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Reset Password',
                  onPressed: _handleResetPassword,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleSendResetLink() async {
    if (_formKey.currentState?.validate() ?? false) {
      final notifier = context.read<AuthNotifier>();
      await notifier.resetPassword(_emailController.text);

      if (!mounted) return;
      if (notifier.state.isSuccess) {
        setState(() => isEmailSent = true);
      }
      if (notifier.state.isFailure) {
        DialogUtils.showFailureDialog(
          context,
          theme: Theme.of(context),
          message: notifier.state.error,
        );
      }
    }
  }

  void _handleResetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final notifier = context.read<AuthNotifier>();

      try {
        // Get token from URL or state
        final token = GoRouterState.of(context).uri.queryParameters['token'];
        if (token == null) {
          throw AppExceptions('Invalid reset token');
        }

        await notifier.updatePasswordWithToken(token, _passwordController.text);

        if (!mounted) return;

        if (notifier.state.isSuccess) {
          DialogUtils.showSuccessDialog(
            context,
            theme: Theme.of(context),
            message: 'Password reset successful',
            onPressed: () {
              context.go(AppRoutes.loginScreen);
              notifier.resetState();
            },
          );
        } else if (notifier.state.isFailure) {
          DialogUtils.showFailureDialog(
            context,
            theme: Theme.of(context),
            message: notifier.state.error,
            onPressed: () {
              notifier.resetState();
            },
          );
        }
      } catch (error) {
        DialogUtils.showFailureDialog(
          context,
          theme: Theme.of(context),
          message: error.toString(),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
