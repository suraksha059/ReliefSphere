import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:relief_sphere/app/const/app_assets.dart';
import 'package:relief_sphere/app/enum/enum.dart';
import 'package:relief_sphere/app/routes/app_routes.dart';
import 'package:relief_sphere/presentation/widgets/loading_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../app/config/size_config.dart';
import '../../../core/notifiers/auth/auth_notifiers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dialogs/dialog_utils.dart';
import 'widgets/social_login_button.dart';

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

    return Consumer<AuthNotifier>(builder: (context, notifier, child) {
      return LoadingOverlay(
        isLoading: notifier.isLoading,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Hero(
                        tag: 'app_logo',
                        child: Image.asset(
                          AppAssets.logo,
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Welcome to ReliefSphere',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Login to help or receive aid',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Email & Password Fields
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

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Navigate to forgot password
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: colorScheme.primary),
                          ),
                        ),
                      ),

                      // Login Button
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Login',
                        onPressed: () => _handleLogin(theme),
                        isLoading: notifier.isLoading,
                      ),

                      // Social Login Divider
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(child: Divider(color: colorScheme.outline)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(
                                  color: colorScheme.onSurfaceVariant),
                            ),
                          ),
                          Expanded(child: Divider(color: colorScheme.outline)),
                        ],
                      ),

                      // Social Login Buttons
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialLoginButton(
                            platformName: 'Google',
                            icon: AppAssets.googleLogo,
                            onPressed: () {
                              notifier.socialLogin(SocialLoginType.google);
                            },
                          ),
                          SizedBox(width: SizeConfig.blockSizeHorizontal * 4),
                          SocialLoginButton(
                            platformName: 'Facebook',
                            icon: AppAssets.facebookLogo,
                            onPressed: () {
                              notifier.socialLogin(SocialLoginType.facebook);
                            },
                          ),
                        ],
                      ),

                      // Sign Up Link
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account? ',
                            style:
                                TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(AppRoutes.registerScreen);
                            },
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
      );
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(ThemeData theme) async {
    if (_formKey.currentState?.validate() ?? false) {
      TextInput.finishAutofillContext();
      try {
        await context.read<AuthNotifier>().login(
              _emailController.text,
              _passwordController.text,
            );
        if (mounted) {
          context.go(AppRoutes.homeScreen);
        }
      } on AuthException catch (e) {
        if (mounted) {
          DialogUtils.showFailureDialog(
            context,
            theme: theme,
            title: "Login Failed",
            message: e.message,
          );
        }
      } catch (e) {
        if (mounted) {
          DialogUtils.showFailureDialog(
            context,
            theme: theme,
            title: "Signup Failed",
            message: "Please try again later",
          );
        }
      }
    }
  }
}
