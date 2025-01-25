import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddClusterScreen extends StatefulWidget {
  const AddClusterScreen({super.key});

  @override
  State<AddClusterScreen> createState() => _AddClusterScreenState();
}

class _AddClusterScreenState extends State<AddClusterScreen> {
  final _formKey = GlobalKey<FormState>();
  late GoogleMapController _mapController;
  LatLng _selectedLocation = const LatLng(27.7172, 85.3240);
  String _selectedStatus = 'Active';
  final List<String> _statuses = ['Active', 'Standby', 'Critical'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Aid Cluster',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: _saveCluster,
            icon: const Icon(Icons.check),
            label: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Selector
              Container(
                height: 250,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withAlpha(20),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation,
                      zoom: 15,
                    ),
                    onMapCreated: (controller) => _mapController = controller,
                    onTap: (location) {
                      setState(() => _selectedLocation = location);
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: _selectedLocation,
                      ),
                    },
                  ),
                ),
              ),

              // Form Fields
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cluster Details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Cluster Name',
                        hintText: 'e.g., Kathmandu Central Aid Hub',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.hub),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter cluster name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Coverage Area (km)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter coverage area';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Status Selector
                    Text(
                      'Cluster Status',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _statuses.map((status) {
                        final isSelected = _selectedStatus == status;
                        return ChoiceChip(
                          selected: isSelected,
                          label: Text(status),
                          onSelected: (selected) {
                            setState(() => _selectedStatus = status);
                          },
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          selectedColor:
                              _getStatusColor(status, theme).withOpacity(0.2),
                          labelStyle: theme.textTheme.labelLarge?.copyWith(
                            color: isSelected
                                ? _getStatusColor(status, theme)
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Resources Section
                    Text(
                      'Available Resources',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildResourceInput(
                      theme,
                      icon: Icons.medical_services_outlined,
                      label: 'Medical Supplies',
                    ),
                    const SizedBox(height: 12),
                    _buildResourceInput(
                      theme,
                      icon: Icons.food_bank_outlined,
                      label: 'Food Supplies',
                    ),
                    const SizedBox(height: 12),
                    _buildResourceInput(
                      theme,
                      icon: Icons.home_outlined,
                      label: 'Shelter Capacity',
                    ),

                    const SizedBox(height: 24),

                    // Contact Information
                    Text(
                      'Contact Information',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Coordinator Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter coordinator name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Emergency Contact',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter emergency contact';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceInput(
    ThemeData theme, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleSmall,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter quantity',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status) {
      case 'Active':
        return theme.colorScheme.primary;
      case 'Standby':
        return theme.colorScheme.tertiary;
      case 'Critical':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.primary;
    }
  }

  void _saveCluster() {
    if (_formKey.currentState?.validate() ?? false) {
      // Implement save logic
    }
  }
}
