import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:relief_sphere/app/const/app_assets.dart';
import 'package:relief_sphere/app/routes/app_routes.dart';
import 'package:relief_sphere/presentation/widgets/dialogs/dialog_utils.dart';
import 'package:relief_sphere/presentation/widgets/loading_overlay.dart';

import '../../../core/notifiers/auth/auth_notifiers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _acceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Consumer<AuthNotifier>(
      builder: (context, notifier, child) {
        return LoadingOverlay(
          isLoading: notifier.state.isLoading,
          child: Scaffold(
            body: Container(
              height: size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.1, 0.5, 0.9],
                  colors: [
                    theme.colorScheme.surface,
                    theme.colorScheme.primaryContainer.withOpacity(0.1),
                    theme.colorScheme.surface,
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: size.height * 0.02,
                  ),
                  child: Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: size.height * 0.02),
                          Hero(
                            tag: 'app_logo',
                            child: Image.asset(
                              AppAssets.logo,
                              height: size.height * 0.15,
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          Text(
                            'Create Account',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colorScheme.primary,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Join ReliefSphere to make a difference',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.height * 0.04),
                          Column(
                            children: [
                              PrimaryTextField(
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                label: 'Email',
                                controller: _emailController,
                                prefixIcon: Icons.email_outlined,
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
                              const SizedBox(height: 16),
                              PrimaryTextField(
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [
                                  AutofillHints.newPassword
                                ],
                                label: 'Password',
                                controller: _passwordController,
                                isObscure: true,
                                prefixIcon: Icons.lock_outline,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter your password';
                                  }
                                  if (value!.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _acceptedTerms,
                                      onChanged: (value) => setState(
                                          () => _acceptedTerms = value!),
                                    ),
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          text: 'I agree to the ',
                                          children: [
                                            TextSpan(
                                              text: 'Terms & Conditions',
                                              style: TextStyle(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                        style: TextStyle(
                                            color: theme
                                                .colorScheme.onSurfaceVariant),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Signup Button
                              const SizedBox(height: 24),
                              CustomButton(
                                text: 'Sign Up',
                                onPressed: () => _handleSignup(theme),
                                isLoading: notifier.state.isLoading,
                              ),
                            ],
                          ),

                          // Social Signup
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.colorScheme.outline
                                            .withOpacity(0),
                                        theme.colorScheme.outline,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.colorScheme.outline,
                                        theme.colorScheme.outline
                                            .withOpacity(0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                    color: colorScheme.onSurfaceVariant),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignup(ThemeData theme) async {
    final notifier = context.read<AuthNotifier>();
    if (_formKey.currentState?.validate() ?? false) {
      TextInput.finishAutofillContext();
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept terms & conditions')),
        );
        return;
      }

      await notifier.register(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      if (notifier.state.isSuccess) {
        context.go(AppRoutes.profileSetupScreen);
        notifier.resetState();
      }
      if (notifier.state.isFailure) {
        DialogUtils.showFailureDialog(
          context,
          theme: theme,
          title: 'Signup Failed',
          message: notifier.state.error,
          onPressed: () {
            context.pop();
            notifier.resetState();
          },
        );
      }
    }
  }
}
