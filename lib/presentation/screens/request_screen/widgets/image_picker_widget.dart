import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  static const int maxImages = 4;
  final List<XFile> images;
  final Function(XFile) onRemove;
  final VoidCallback onAdd;

  const ImagePickerWidget({
    super.key,
    required this.images,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Add Photos',
              
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${widget.images.length}/${ImagePickerWidget.maxImages}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              if (widget.images.length < ImagePickerWidget.maxImages)
                _buildAddImageButton(colorScheme),
              ...widget.images
                  .map((image) => _buildImagePreview(image, colorScheme)),
            ],
          ),
        ),
        if (widget.images.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Tap on the image to remove',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddImageButton(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: _isLoading ? null : widget.onAdd,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 32,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                'Add Photo',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(XFile image, ColorScheme colorScheme) {
    return Hero(
      tag: image.path,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(image.path),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: colorScheme.errorContainer,
                        child: Icon(
                          Icons.error_outline,
                          color: colorScheme.error,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton.filledTonal(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => widget.onRemove(image),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.surface.withOpacity(0.7),
                          foregroundColor: colorScheme.error,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
