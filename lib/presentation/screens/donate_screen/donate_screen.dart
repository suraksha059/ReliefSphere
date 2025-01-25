import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:relief_sphere/app/const/app_constant.dart';
import 'package:relief_sphere/app/routes/app_routes.dart';
import 'package:relief_sphere/presentation/screens/request_screen/request_type.dart';

import '../../../core/model/user_model.dart';

class DonateScreen extends StatefulWidget {
  final UserRole userRole;

  const DonateScreen({
    super.key,
    required this.userRole,
  });

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  String _selectedCategory = 'All';
  String _selectedUrgency = 'All';
  final List<String> _urgencyLevels = [
    'All',
    'Critical',
    'High',
    'Medium',
    'Low'
  ];

  // Add mock data
  final List<String> _mockImages = [
    AppConstant.dummyImageUrl,
    AppConstant.dummyImageUrl,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aid Requests',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildFilterSection(theme),
          ),

          // Request List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 10, // Example count
              itemBuilder: (context, index) {
                return _buildRequestCard(theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(ThemeData theme) {
    return Column(
      children: [
        // Search Bar
        TextField(
          decoration: InputDecoration(
            hintText: 'Search requests...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest,
          ),
        ),
        const SizedBox(height: 16),
        // Category Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...RequestType.values.map((category) {
                final isSelected = _selectedCategory == category.name;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(category.name),
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category.name);
                    },
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    selectedColor: theme.colorScheme.primaryContainer,
                    labelStyle: theme.textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Urgency Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _urgencyLevels.map((urgency) {
              final isSelected = _selectedUrgency == urgency;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(urgency),
                  onSelected: (selected) {
                    setState(() => _selectedUrgency = urgency);
                  },
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  selectedColor:
                      _getUrgencyColor(urgency, theme).withOpacity(0.2),
                  labelStyle: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? _getUrgencyColor(urgency, theme)
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest.withAlpha(128),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(128),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showRequestDetails(context),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_mockImages.isNotEmpty)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(_mockImages.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        _buildUrgencyBadge(theme, 'Critical'),
                        const Spacer(),
                        _buildTypeChip(theme, RequestType.food),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Title and Description
                    Text(
                      'Food & Medical Supplies Needed',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Family of 5 needs immediate assistance with food and medical supplies...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Location Info
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Kathmandu, Nepal • 2.5 km away',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.6,
                        minHeight: 8,
                        backgroundColor:
                            theme.colorScheme.primaryContainer.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Progress Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹6,000 raised of ₹10,000',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '2 hours ago',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Action Buttons
                    widget.userRole == UserRole.admin
                        ? Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () => _verifyRequest(context),
                                  icon: const Icon(Icons.verified_outlined),
                                  label: const Text(
                                    'Verify Request',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        theme.colorScheme.primaryContainer,
                                    foregroundColor: theme.colorScheme.primary,
                                    minimumSize:
                                        const Size(double.infinity, 48),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () => _verifyRequest(context),
                                  icon: const Icon(
                                      Icons.report_problem_outlined,
                                      color: Colors.red),
                                  label: const Text('Mark Fraud'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        theme.colorScheme.errorContainer,
                                    foregroundColor: theme.colorScheme.error,
                                    minimumSize:
                                        const Size(double.infinity, 48),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : FilledButton.icon(
                            onPressed: () {
                              context.push(AppRoutes.donateNowScreen);
                            },
                            icon: const Icon(Icons.favorite_outline),
                            label: const Text('Donate Now'),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                            ),
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

  Widget _buildTypeChip(ThemeData theme, RequestType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            type.icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text(
            type.name,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencyBadge(ThemeData theme, String urgency) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getUrgencyColor(urgency, theme).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: _getUrgencyColor(urgency, theme),
          ),
          const SizedBox(width: 4),
          Text(
            urgency,
            style: theme.textTheme.labelMedium?.copyWith(
              color: _getUrgencyColor(urgency, theme),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getUrgencyColor(String urgency, ThemeData theme) {
    switch (urgency) {
      case 'Critical':
        return theme.colorScheme.error;
      case 'High':
        return theme.colorScheme.error.withOpacity(0.8);
      case 'Medium':
        return theme.colorScheme.tertiary;
      case 'Low':
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.primary;
    }
  }

  void _markAsFraud(BuildContext context) {
    // Implement fraud marking logic
  }

  void _showRequestDetails(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerHighest.withAlpha(230),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag Handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant.withAlpha(128),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Map Container (Fixed Height)
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(27.7172, 85.3240),
                    zoom: 15,
                  ),
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  myLocationButtonEnabled: false,
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Profile Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Requester Profile
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Icon(Icons.person_outline,
                                    color: theme.colorScheme.primary),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'John Doe',
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '2.5 km away • Kathmandu, Nepal',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FilledButton.tonalIcon(
                                onPressed: () {},
                                icon: const Icon(Icons.chat_outlined),
                                label: const Text('Contact'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Request Details Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest
                                  .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: theme.colorScheme.error,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Critical Need',
                                      style:
                                          theme.textTheme.titleSmall?.copyWith(
                                        color: theme.colorScheme.error,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Family of 5 needs immediate assistance with food and medical supplies.',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Progress Section
                          Text(
                            'Donation Progress',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: 0.6,
                              minHeight: 8,
                              backgroundColor: theme
                                  .colorScheme.primaryContainer
                                  .withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹6,000 raised of ₹10,000',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '60%',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Donation Button
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
              child: FilledButton.icon(
                onPressed: () {
                  context.push(AppRoutes.donateNowScreen);
                },
                icon: const Icon(Icons.favorite_outline),
                label: const Text('Donate Now'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyRequest(BuildContext context) {
    // Implement verification logic
  }

  void _veryfyRequest(BuildContext context) {
    // Implement verification logic
  }
}
