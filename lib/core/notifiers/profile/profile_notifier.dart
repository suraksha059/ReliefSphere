import 'package:relief_sphere/core/apis/profile_api.dart';
import 'package:relief_sphere/core/notifiers/base_notifier.dart';

import '../../../app/services/secure_storage_service.dart';
import '../../../app/services/service_locator.dart';
import 'profile_state.dart';

class ProfileNotifier extends BaseNotifier<ProfileState> {
  final ProfileApi _profileApi = ProfileApi();
  final SecureStorageService _secureStorage = ServiceLocator.secureStorage;

  ProfileNotifier() : super(const ProfileState());

  void getUserProfile() async {
    await handleAsyncOperation(() async {
      final user = await _profileApi.getUserProfile(
          userId: await _secureStorage.getUserId());
      state = state.copyWith(userModel: user) as ProfileState;
    });
  }
}
