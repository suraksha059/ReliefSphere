import 'dart:io';

import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:relief_sphere/app/routes/app_routes.dart';
import 'package:relief_sphere/core/model/user_model.dart';
import 'package:relief_sphere/core/notifiers/auth/auth_notifiers.dart';
import 'package:relief_sphere/presentation/widgets/custom_text_field.dart';
import 'package:relief_sphere/presentation/widgets/dialogs/dialog_utils.dart';
import 'package:relief_sphere/presentation/widgets/loading_overlay.dart';

import '../../../app/const/app_assets.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  UserRole _selectedRole = UserRole.victim;
  XFile? _selectedImage;
  int _currentStep = 0;
  final _additionalDetailsController = TextEditingController();
  bool _locationPermissionGranted = false;
  final Set<String> _selectedPreferences = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<AuthNotifier>(builder: (context, notifier, child) {
      return LoadingOverlay(
        isLoading: notifier.state.isLoading,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: _currentStep > 0
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _previousStep,
                  )
                : null,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surfaceContainerHighest.withAlpha(230),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: (_currentStep + 1) / 3,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Step ${_currentStep + 1} of 3',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: _buildStepContent(theme),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.surface.withOpacity(0),
                          theme.colorScheme.surface,
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        if (_currentStep > 0)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _previousStep,
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Back'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 56),
                              ),
                            ),
                          ),
                        if (_currentStep > 0) const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: FilledButton.icon(
                            onPressed: _currentStep < 2
                                ? _nextStep
                                : () => _completeProfile(theme),
                            icon: Icon(_currentStep < 2
                                ? Icons.arrow_forward
                                : Icons.check),
                            label: Text(_currentStep < 2
                                ? 'Continue'
                                : 'Complete Profile'),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(0, 56),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAdditionalDetailsStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedRole == UserRole.donor
              ? 'Donation Preferences'
              : 'Additional Information',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surfaceContainerHighest.withAlpha(128),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withAlpha(128),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_selectedRole == UserRole.donor) ...[
                _buildPreferenceChip(theme, 'Food Aid'),
                _buildPreferenceChip(theme, 'Medical Supplies'),
                _buildPreferenceChip(theme, 'Emergency Support'),
                const SizedBox(height: 16),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Additional Notes',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ] else ...[
                PrimaryTextField(
                  maxLines: 3,
                  controller: _additionalDetailsController,
                  label: "Brief description of your situation",
                )
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complete Your Profile',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Let\'s set up your profile to get started',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),

        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 64,
                backgroundColor: theme.colorScheme.primaryContainer,
                backgroundImage: _selectedImage != null
                    ? FileImage(File(_selectedImage!.path))
                    : null,
                child: _selectedImage == null
                    ? Icon(
                        Icons.person_outline,
                        size: 64,
                        color: theme.colorScheme.primary,
                      )
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    color: theme.colorScheme.onPrimary,
                    onPressed: _pickImage,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // User Details Form
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surfaceContainerHighest.withAlpha(128),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withAlpha(128),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              Text(
                'I want to',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildRoleCard(
                      theme,
                      role: UserRole.victim,
                      title: 'Get Help',
                      icon: Icons.help_outline,
                      description: 'Request aid and support',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildRoleCard(
                      theme,
                      role: UserRole.donor,
                      title: 'Donate',
                      icon: Icons.volunteer_activism,
                      description: 'Provide aid to others',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationPermissionStep(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DotLottieLoader.fromAsset(AppAssets.locationPermission,
            frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
          if (dotlottie != null) {
            return Lottie.memory(dotlottie.animations.values.single);
          } else {
            return Container();
          }
        }),
        const SizedBox(height: 24),
        Text(
          'Enable Location Services',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'We need your location for ${_selectedRole == UserRole.donor ? 'requests' : 'donors'}',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed: _requestLocationPermission,
          icon: const Icon(Icons.my_location),
          label: const Text('Enable Location'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(200, 56),
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceChip(ThemeData theme, String label) {
    final isSelected = _selectedPreferences.contains(label);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FilterChip(
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            if (selected) {
              _selectedPreferences.add(label);
            } else {
              _selectedPreferences.remove(label);
            }
          });
        },
        label: Text(label),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        selectedColor: theme.colorScheme.primaryContainer,
        checkmarkColor: theme.colorScheme.primary,
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withAlpha(128),
        ),
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildRoleCard(
    ThemeData theme, {
    required UserRole role,
    required String title,
    required IconData icon,
    required String description,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surface,
              isSelected
                  ? theme.colorScheme.primaryContainer.withOpacity(0.7)
                  : theme.colorScheme.surfaceContainerHighest.withAlpha(128),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withAlpha(128),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(ThemeData theme) {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep(theme);
      case 1:
        return _buildAdditionalDetailsStep(theme);
      case 2:
        return _buildLocationPermissionStep(theme);
      default:
        return const SizedBox.shrink();
    }
  }

  void _completeProfile(ThemeData theme) async {
    final notifier = context.read<AuthNotifier>();
    await notifier.profileSetup(
      name: _nameController.text,
      phoneNumber: _phoneController.text,
      userRole: _selectedRole,
    );
    if (!mounted) return;
    if (notifier.state.isSuccess) {
      DialogUtils.showSuccessDialog(
        context,
        theme: theme,
        message: "Profile created successfully",
        onPressed: () {
          context.go(AppRoutes.homeScreen);
          notifier.resetState();
        },
      );
    }
    if (notifier.state.isFailure) {
      DialogUtils.showFailureDialog(context,
          theme: theme, message: notifier.state.error, onPressed: () {
        context.pop();
        notifier.resetState();
      });
    }
  }

  void _nextStep() {
    if (_formKey.currentState?.validate() == false) return;
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  Future<void> _requestLocationPermission() async {
    setState(() => _locationPermissionGranted = true);
  }
}
