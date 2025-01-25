import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  String _selectedCategory = 'All';
  final double _selectedRadius = 5.0; // in km

  final List<String> _categories = [
    'All',
    'Food',
    'Medical',
    'Shelter',
    'Education'
  ];
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Map View
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(27.7172, 85.3240), // Kathmandu
              zoom: 12,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Search & Filter Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.surface,
                          theme.colorScheme.surfaceContainerHighest
                              .withAlpha(230),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withAlpha(128),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withAlpha(20),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search area...',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Category Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSelected,
                            label: Text(category),
                            onSelected: (selected) {
                              setState(() => _selectedCategory = category);
                            },
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            selectedColor: theme.colorScheme.primaryContainer,
                            labelStyle: theme.textTheme.labelLarge?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Controls Panel
          Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 100,
            child: Column(
              children: [
                _buildMapControl(
                  icon: Icons.layers_outlined,
                  onTap: () {/* Toggle map layers */},
                  theme: theme,
                ),
                const SizedBox(height: 8),
                _buildMapControl(
                  icon: Icons.my_location,
                  onTap: () {/* Center on user */},
                  theme: theme,
                ),
                const SizedBox(height: 8),
                _buildMapControl(
                  icon: Icons.radio_button_checked,
                  onTap: () {/* Show radius selector */},
                  theme: theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControl({
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest.withAlpha(230),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(128),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}
