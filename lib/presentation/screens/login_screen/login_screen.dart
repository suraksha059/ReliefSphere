import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:relief_sphere/app/const/app_assets.dart';
import 'package:relief_sphere/app/routes/app_routes.dart';
import 'package:relief_sphere/presentation/widgets/loading_overlay.dart';

import '../../../core/notifiers/auth/auth_notifiers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dialogs/dialog_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                    vertical: size.height * 0.05,
                  ),
                  child: Form(
                    key: _formKey,
                    child: AutofillGroup(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: size.height * 0.05),
                          Hero(
                            tag: 'app_logo',
                            child: Image.asset(
                              AppAssets.logo,
                              height: size.height * 0.15,
                            ),
                          ),
                          SizedBox(height: size.height * 0.04),
                          Text(
                            'Welcome to ReliefSphere',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colorScheme.primary,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Login to help or receive aid',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.height * 0.06),
                          Column(
                            children: [
                              PrimaryTextField(
                                label: 'Email',
                                controller: _emailController,
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
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
                                label: 'Password',
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [AutofillHints.password],
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
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: colorScheme.primary,
                                  ),
                                  child: const Text('Forgot Password?'),
                                ),
                              ),
                              const SizedBox(height: 24),
                              CustomButton(
                                text: 'Login',
                                onPressed: () => _handleLogin(theme),
                                isLoading: notifier.state.isLoading,
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.04),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorScheme.outline.withOpacity(0),
                                        colorScheme.outline,
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
                                        colorScheme.outline,
                                        colorScheme.outline.withOpacity(0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account? ',
                                style: TextStyle(
                                    color: colorScheme.onSurfaceVariant),
                              ),
                              TextButton(
                                onPressed: () =>
                                    context.push(AppRoutes.registerScreen),
                                child: Text(
                                  'Sign up',
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

  void _handleLogin(ThemeData theme) async {
    final notifier = context.read<AuthNotifier>();
    if (_formKey.currentState?.validate() ?? false) {
      TextInput.finishAutofillContext();

      await context.read<AuthNotifier>().login(
            _emailController.text,
            _passwordController.text,
          );

      if (!mounted) return;
      if (notifier.state.isSuccess) {
        context.go(AppRoutes.homeScreen);
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
