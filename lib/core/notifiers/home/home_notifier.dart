import 'package:relief_sphere/app/services/secure_storage_service.dart';
import 'package:relief_sphere/app/services/service_locator.dart';
import 'package:relief_sphere/core/apis/home_api.dart';
import 'package:relief_sphere/core/notifiers/base_notifier.dart';
import 'package:relief_sphere/core/notifiers/home/home_state.dart';

import '../base_state.dart';

class HomeNotifier extends BaseNotifier<HomeState> {
  final HomeApi _homeApi = HomeApi();
  final SecureStorageService _secureStorage = ServiceLocator.secureStorage;

  HomeNotifier() : super(const HomeState());

  Future<void> getDashboardItems() async {
    await handleAsyncOperation(() async {
      final userId = await _secureStorage.getUserId();
      final requests = await _homeApi.getDashboardItems(userId: userId);

      state = state.copyWith(
        activeRequests: requests.activeRequests,
        pendingRequests: requests.pendingRequests,
        aidReceived: requests.aidReceived,
        status: Status.success,
      );
    });
  }
}
