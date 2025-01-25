import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Add Photos (Optional)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${images.length}/$maxImages',
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
              if (images.length < maxImages)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: onAdd,
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
                ),
              ...images.map((image) {
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
                              Image.network(
                                image.path,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 4,
                                top: 4,
                                child: Material(
                                  color: Colors.transparent,
                                  child: IconButton.filledTonal(
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () => onRemove(image),
                                    style: IconButton.styleFrom(
                                      backgroundColor:
                                          colorScheme.surface.withOpacity(0.7),
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
              }),
            ],
          ),
        ),
        if (images.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Tap and hold to rearrange photos',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
      ],
    );
  }
}
