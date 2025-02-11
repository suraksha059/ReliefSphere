import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'home_model.g.dart';

@JsonSerializable()
class HomeModel extends Equatable {
  @JsonKey(name: 'active_requests')
  final int activeRequests;

  @JsonKey(name: 'pending_requests')
  final int pendingRequests;

  @JsonKey(name: 'aid_received')
  final int aidReceived;

  @JsonKey(name: 'last_updated')
  final DateTime? lastUpdated;

  const HomeModel({
    required this.activeRequests,
    required this.pendingRequests,
    required this.aidReceived,
    this.lastUpdated,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeModelToJson(this);

  @override
  List<Object?> get props => [activeRequests, pendingRequests, aidReceived, lastUpdated];

  HomeModel copyWith({
    int? activeRequests,
    int? pendingRequests,
    int? aidReceived,
    DateTime? lastUpdated,
  }) {
    return HomeModel(
      activeRequests: activeRequests ?? this.activeRequests,
      pendingRequests: pendingRequests ?? this.pendingRequests,
      aidReceived: aidReceived ?? this.aidReceived,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}