import 'package:relief_sphere/app/config/size_config.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:relief_sphere/app/routes/app_routes.dart';
import 'package:relief_sphere/core/notifiers/request/request_notifier.dart';
import 'package:relief_sphere/core/utils/urgency_utils.dart';

import '../../../core/model/request_model.dart';
import '../../../core/model/user_model.dart';
import '../../../core/utils/icon_utils.dart';
import '../../widgets/custom_image_viewer.dart';
import '../../widgets/dialogs/dialog_utils.dart';

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
  UrgencyLevel _selectedUrgency = UrgencyLevel.critical;
  final List<UrgencyLevel> _urgencyLevels = [
    UrgencyLevel.critical,
    UrgencyLevel.veryHigh,
    UrgencyLevel.high,
    UrgencyLevel.moderate,
    UrgencyLevel.low,
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getRequests();
    });
    super.initState();
  }

  void _getRequests() {
    final notifier = context.read<RequestNotifier>();

    notifier.getPendingAndVerifiedRequest(widget.userRole);
  }

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
            child:
                Consumer<RequestNotifier>(builder: (context, notifier, child) {
              if (notifier.state.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifier
                    .state.pendingAndVerifiedRequests.length, // Example count
                itemBuilder: (context, index) {
                  return _buildRequestCard(theme,
                      request:
                          notifier.state.pendingAndVerifiedRequests[index]);
                },
              );
            }),
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
                  label: Text(urgency.name),
                  onSelected: (selected) {
                    setState(() => _selectedUrgency = urgency);
                  },
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  selectedColor: UrgencyUtils.getUrgencyColor(
                    urgency,
                    theme: theme,
                  ).withOpacity(0.2),
                  labelStyle: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? UrgencyUtils.getUrgencyColor(
                            urgency,
                            theme: theme,
                          )
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

  Widget _buildRequestCard(ThemeData theme, {required RequestModel request}) {
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
          onTap: () => _showRequestDetails(context, request: request),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (request.images != null && request.images!.isNotEmpty)
                Container(
                  clipBehavior: Clip.hardEdge,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: CustomImageViewer(images: request.images!),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        _buildUrgencyBadge(theme, request.urgencyLevel),
                        const Spacer(),
                        _buildTypeChip(theme, request.type),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Title and Description
                    Text(
                      request.title ?? 'No title available',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      request.description,
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
                        SizedBox(
                          width: SizeConfig.screenWidth - 86,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: SizeConfig.blockSizeHorizontal * 46,
                                child: Text(
                                  '${request.address}',
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              Text(
                                '2.5 km away',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Progress Bar

                    // Progress Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timeago.format(request.date ?? DateTime.now()),
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
                                  onPressed: () => _verifyRequest(
                                      context, request.id ?? 0, false),
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
                                  onPressed: () => _verifyRequest(
                                      context, request.id ?? 0, true),
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
                              context.push(AppRoutes.donateNowScreen,
                                  extra: request);
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
            getRequestTypeIcon(type),
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

  Widget _buildUrgencyBadge(ThemeData theme, UrgencyLevel urgency) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: UrgencyUtils.getUrgencyColor(urgency, theme: theme)
            .withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: UrgencyUtils.getUrgencyColor(urgency, theme: theme),
          ),
          const SizedBox(width: 4),
          Text(
            urgency.name,
            style: theme.textTheme.labelMedium?.copyWith(
              color: UrgencyUtils.getUrgencyColor(urgency, theme: theme),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestDetails(BuildContext context,
      {required RequestModel request}) {
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
                  context.push(AppRoutes.donateNowScreen, extra: request);
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

  void _verifyRequest(BuildContext context, int id, bool isFraud) async {
    final notifier = context.read<RequestNotifier>();
    await notifier.verifyRequest(id: id, isFraud: isFraud);
    if (!mounted) return;
    if (!context.mounted) return;

    if (notifier.state.isSuccess) {
      DialogUtils.showSuccessDialog(context, onPressed: () {
        context.pop();
        notifier.getPendingAndVerifiedRequest(widget.userRole);
      }, theme: Theme.of(context), message: 'Request verified successfully');
    }
    if (notifier.state.isFailure) {
      DialogUtils.showFailureDialog(
        context,
        theme: Theme.of(context),
        title: 'Unable to verify request',
        message: notifier.state.error,
      );
    }
  }
}
