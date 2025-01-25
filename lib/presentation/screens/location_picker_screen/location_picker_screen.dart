import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController; // Make nullable
  LatLng? _selectedLocation;
  String _address = '';
  bool _isLoading = false;
  bool _isMapLoading = true; // Add loading state

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
      ),
      body: Stack(
        children: [
          // Map
          if (_isMapLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLocation ??
                    const LatLng(27.7172, 85.3240), // Default: Kathmandu
                zoom: 15,
              ),
              onMapCreated: (controller) {
                setState(() => _mapController = controller);
              },
              onCameraMove: (position) {
                _selectedLocation = position.target;
              },
              onCameraIdle: _updateAddress,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),

          // Center Marker
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Icon(
                Icons.location_pin,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
          ),

          // Search Bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search location...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                onSubmitted: _searchLocation,
              ),
            ),
          ),

          // Location Details Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Location',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        if (_isLoading)
                          const LinearProgressIndicator()
                        else
                          Text(
                            _address.isEmpty
                                ? 'Move map to select location'
                                : _address,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _selectedLocation != null
                              ? () => _confirmLocation(context)
                              : null,
                          icon: const Icon(Icons.check),
                          label: const Text('Confirm Location'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Current Location Button
          Positioned(
            bottom: 200,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'currentLocation',
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose(); // Safe disposal
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _confirmLocation(BuildContext context) {
    Navigator.pop(context, {
      'location': _selectedLocation,
      'address': _address,
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_selectedLocation!),
      );
      await _updateAddress();
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _initializeLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    await _getCurrentLocation();
    setState(() => _isMapLoading = false);
  }

  Future<void> _searchLocation(String query) async {
    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        _selectedLocation = LatLng(location.latitude, location.longitude);
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(_selectedLocation!),
        );
      }
    } catch (e) {
      debugPrint('Error searching location: $e');
    }
  }

  Future<void> _updateAddress() async {
    if (_selectedLocation == null) return;

    setState(() => _isLoading = true);
    try {
      final placemarks = await placemarkFromCoordinates(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
        });
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
