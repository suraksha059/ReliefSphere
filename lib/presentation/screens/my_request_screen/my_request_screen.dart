import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:relief_sphere/app/routes/app_routes.dart';
import 'package:relief_sphere/core/notifiers/request/request_notifier.dart';
import 'package:relief_sphere/presentation/screens/my_request_screen/widgets/my_request_card.dart';

import '../../../core/model/user_model.dart';
import '../dashboard_screen/widgets/dashboard_app_bar.dart';

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({super.key, required this.isHome});
  final bool isHome;

  @override
  State<MyRequestScreen> createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestNotifier>().getMyRequest();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          widget.isHome
              ? const DashboardSliverAppBar(
                  userRole: UserRole.victim,
                )
              : SliverAppBar(
                  pinned: true,
                  title: Text('Track aid'),
                ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'My Requests',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Active', 'Completed'].map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            selected: isSelected,
                            label: Text(filter),
                            onSelected: (value) {
                              setState(() => _selectedFilter = filter);
                            },
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            selectedColor: theme.colorScheme.primaryContainer,
                            checkmarkColor: theme.colorScheme.primary,
                            labelStyle: theme.textTheme.labelLarge?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
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
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver:
                Consumer<RequestNotifier>(builder: (context, notifier, child) {
              return SliverList.builder(
                itemBuilder: (context, index) {
                  return MyRequestCard(
                    request: notifier.state.myRequests[index],
                  );
                },
                itemCount: notifier.state.myRequests.length,
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.newRequestScreen);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
    );
  }
}
