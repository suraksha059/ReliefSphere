import 'package:relief_sphere/core/apis/request_api.dart';
import 'package:relief_sphere/core/model/address_model.dart';
import 'package:relief_sphere/core/model/request_model.dart';
import 'package:relief_sphere/core/model/user_model.dart';
import 'package:relief_sphere/core/notifiers/base_notifier.dart';

import '../../../app/services/secure_storage_service.dart';
import '../../../app/services/service_locator.dart';
import '../../model/donation_model.dart';
import '../base_state.dart';
import 'request_state.dart';

class RequestNotifier extends BaseNotifier<RequestState> {
  final RequestApi _requestApi = RequestApi();
  final SecureStorageService _secureStorage = ServiceLocator.secureStorage;
  AddressModel? location;
  DonationModel? donation;

  RequestNotifier() : super(const RequestState());

  Future<void> getMyRequest() async {
    await handleAsyncOperation(() async {
      final userId = await _secureStorage.getUserId();
      final requests = await _requestApi.getMyRequest(userId);
      state = state.copyWith(myRequests: requests, status: Status.success);
    });
  }

  Future<void> getAllRequest() async {
    await handleAsyncOperation(() async {
      final requests = await _requestApi.getAllRequest();
      state = state.copyWith(allRequests: requests, status: Status.success);
    });
  }

  Future<void> sendRequest({required RequestModel request}) async {
    await handleAsyncOperation(() async {
      final newRequest = await _requestApi.sendRequest(
          request: request.copyWith(
              lat: location?.latitude,
              long: location?.longitude,
              address: location?.address));
      state = state.copyWith(
        myRequests: [...state.myRequests, newRequest],
        status: Status.success,
      );
    });
  }

  void getDonatedRequest() async {
    await handleAsyncOperation(() async {
      final requests = await _requestApi.getDonatedRequest();
      state = state.copyWith(donatedRequests: requests, status: Status.success);
    });
  }

  void getPendingAndVerifiedRequest(UserRole role) async {
    await handleAsyncOperation(() async {
      final requests = await _requestApi.getPendingAndVerifiedRequest(role);
      state = state.copyWith(
          pendingAndVerifiedRequests: requests, status: Status.success);
    });
  }

  Future verifyRequest({required int id, required bool isFraud}) async {
    await handleAsyncOperation(() async {
      await _requestApi.verifyRequest(id: id, isFreaud: isFraud);
      state = state.copyWith(status: Status.success);
    });
  }

  Future<void> createDonation({
    required int requestId,
    required double amount,
    required String paymentMethod,
  }) async {
    await handleAsyncOperation(() async {
      final userId = await _secureStorage.getUserId();

      final newDonation = DonationModel(
        requestId: requestId,
        donorId: userId!,
        amount: amount,
        paymentMethod: paymentMethod,
        status: DonationStatus.pending,
      );

      final createdDonation =
          await _requestApi.createDonation(donation: newDonation);

      state = state.copyWith(
        createDonations: [createdDonation],
        status: Status.success,
      );
    });
  }

  void setLocation(AddressModel location) {
    this.location = location;
  }
}
