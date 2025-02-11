import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:relief_sphere/app/routes/app_routes.dart';
import 'package:relief_sphere/core/model/request_model.dart';
import 'package:relief_sphere/core/utils/urgency_utils.dart';
import 'package:relief_sphere/presentation/widgets/dialogs/dialog_utils.dart';
import 'package:relief_sphere/presentation/widgets/loading_overlay.dart';

import '../../../core/notifiers/request/request_notifier.dart';
import 'widgets/image_picker_widget.dart';
import 'widgets/request_type_card.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();
  RequestType _selectedType = RequestType.foodAndEssentials;
  int _urgencyLevel = 1;
  final List<XFile> _selectedImages = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<RequestNotifier>(builder: (context, notifier, child) {
        return LoadingOverlay(
          isLoading: notifier.state.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Request Aid'),
              surfaceTintColor: Colors.transparent,
              backgroundColor: theme.colorScheme.surface,
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please enter the title',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Please provide title...',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please describe your situation';
                        }
                        return null;
                      },
                    ),
                    Text(
                      'What type of aid do you need?',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.surface,
                            theme.colorScheme.surfaceContainerHighest
                                .withAlpha(128),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              theme.colorScheme.outlineVariant.withAlpha(128),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withAlpha(13),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: RequestType.values.length,
                        itemBuilder: (context, index) {
                          final type = RequestType.values[index];
                          return RequestTypeCard(
                            type: type,
                            isSelected: _selectedType == type,
                            onTap: () => setState(() => _selectedType = type),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'How urgent is your need?',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.surface,
                            theme.colorScheme.surfaceContainerHighest
                                .withAlpha(128),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              theme.colorScheme.outlineVariant.withAlpha(128),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Urgency Level',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  UrgencyUtils.getUrgencyLevel(_urgencyLevel)
                                      .name,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _urgencyLevel.toDouble(),
                            min: 1,
                            max: 5,
                            divisions: 4,
                            label: UrgencyUtils.getUrgencyLevel(_urgencyLevel)
                                .name,
                            onChanged: (value) {
                              setState(() => _urgencyLevel = value.round());
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Describe your situation',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            'Please provide details about your situation...',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please describe your situation';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.surfaceContainerHighest
                                .withOpacity(0.5),
                            theme.colorScheme.surface,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.push(AppRoutes.locationPicker);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: theme.colorScheme.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context
                                                    .read<RequestNotifier>()
                                                    .location ==
                                                null
                                            ? 'Select Location'
                                            : 'Selected Location',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        context
                                                    .read<RequestNotifier>()
                                                    .location ==
                                                null
                                            ? 'Tap to pick your location'
                                            : context
                                                    .read<RequestNotifier>()
                                                    .location
                                                    ?.address ??
                                                'Tap to pick your location',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.chevron_right,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ImagePickerWidget(
                      images: _selectedImages,
                      onRemove: _removeImage,
                      onAdd: _pickImages,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withAlpha(20),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: FilledButton.icon(
                  onPressed: () => _submitRequest(theme),
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Request'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();
    setState(() {
      _selectedImages.addAll(images);
    });
  }

  void _removeImage(XFile image) {
    setState(() {
      _selectedImages.remove(image);
    });
  }

  void _submitRequest(ThemeData theme) async {
    final notifier = context.read<RequestNotifier>();
    if (_formKey.currentState?.validate() ?? false) {
      if (notifier.location == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please select location to continue')));
        return;
      }

      List<String> imageUrls = [];
      if (_selectedImages.isNotEmpty) {
        imageUrls = await notifier.uploadRequestImages(_selectedImages);
      }

      final RequestModel request = RequestModel(
        type: _selectedType,
        urgencyLevel: UrgencyUtils.getUrgencyLevel(_urgencyLevel),
        description: _descriptionController.text.trim(),
        title: _titleController.text.trim(),
        images: imageUrls,
        lat: notifier.location?.latitude,
        long: notifier.location?.longitude,
        address: notifier.location?.address,
      );

      await notifier.sendRequest(request: request);

      if (!mounted) return;

      if (notifier.state.isSuccess) {
        DialogUtils.showSuccessDialog(context, onPressed: () {
          context.pop();
          context.pop();
        }, theme: theme, message: 'Request sent successfully');
      }

      if (notifier.state.isFailure) {
        DialogUtils.showFailureDialog(
          context,
          theme: theme,
          title: 'Unable to send request',
          message: notifier.state.error,
        );
      }
    }
  }
}
