import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/size_config.dart';
import '../../../app/const/app_assets.dart';

class DialogUtils {
  static void showFailureDialog(
    BuildContext context, {
    required ThemeData theme,
    String? title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant.withAlpha(51),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: SizeConfig.heightMultiplier * 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SvgPicture.asset(
                      AppAssets.errorIcon,
                      height: 180,
                      // colorFilter: ColorFilter.mode(
                      //   theme.colorScheme.error,
                      //   BlendMode.srcIn,
                      // ),
                    ),
                  ),
                  Text(
                    title ?? 'Oops!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onPressed ?? () => context.pop(),
                      child: Text(
                        buttonText ?? "Done",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void showSuccessDialog(
    BuildContext context, {
    required ThemeData theme,
    String? title,
    String? message,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant.withAlpha(51),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: SizeConfig.heightMultiplier * 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 100,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    title ?? 'Success!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message ?? 'Your action was successful',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onPressed ?? () => context.pop(),
                      child: Text(
                        buttonText ?? "Done",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
