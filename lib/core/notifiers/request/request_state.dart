import 'package:relief_sphere/core/model/request_model.dart';
import 'package:relief_sphere/core/notifiers/base_state.dart';

import '../../model/donation_model.dart';

class RequestState extends BaseState {
  final List<RequestModel> myRequests;
  final List<RequestModel> allRequests;
  final List<RequestModel> donatedRequests;
  final List<RequestModel> sendRequests;
  final List<RequestModel> pendingAndVerifiedRequests;
  final List<DonationModel> createDonations;

  const RequestState({
    this.myRequests = const [],
    this.allRequests = const [],
    this.donatedRequests = const [],
    this.sendRequests = const [],
    this.pendingAndVerifiedRequests = const [],
    this.createDonations = const [],
    super.status = Status.initial,
    super.error = '',
  });

  @override
  RequestState copyWith({
    List<RequestModel>? myRequests,
    List<RequestModel>? allRequests,
    List<RequestModel>? donatedRequests,
    List<RequestModel>? sendRequests,
    List<RequestModel>? pendingAndVerifiedRequests,
    List<DonationModel>? createDonations,
    Status? status,
    String? error,
  }) {
    return RequestState(
      myRequests: myRequests ?? this.myRequests,
      allRequests: allRequests ?? this.allRequests,
      donatedRequests: donatedRequests ?? this.donatedRequests,
      sendRequests: sendRequests ?? this.sendRequests,
      pendingAndVerifiedRequests:
          pendingAndVerifiedRequests ?? this.pendingAndVerifiedRequests,
      createDonations: createDonations ?? this.createDonations,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        myRequests,
        allRequests,
        donatedRequests,
        sendRequests,
        pendingAndVerifiedRequests,
        createDonations,
        status,
        error
      ];
}
