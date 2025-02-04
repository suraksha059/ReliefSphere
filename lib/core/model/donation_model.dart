import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'donation_model.g.dart';

@JsonEnum(valueField: 'value')
enum DonationStatus {
  pending('pending'),
  completed('completed'),
  failed('failed'),
  refunded('refunded');

  final String value;
  const DonationStatus(this.value);
}

@JsonSerializable()
class DonationModel extends Equatable {
  @JsonKey(includeToJson: false)
  final int? id;
  
  @JsonKey(name: 'request_id')
  final int requestId;
  
  @JsonKey(name: 'donor_id')
  final String donorId;
  
  final double amount;
  
  @JsonKey(name: 'status', defaultValue: DonationStatus.pending)
  final DonationStatus status;
  
  final String? description;
  
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  
  @JsonKey(name: 'transaction_id')
  final String? transactionId;
  
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime? createdAt;
  
 
  const DonationModel({
    this.id,
    required this.requestId,
    required this.donorId,
    required this.amount,
    this.status = DonationStatus.pending,
    this.description,
    required this.paymentMethod,
    this.transactionId,
    this.createdAt,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) =>
      _$DonationModelFromJson(json);

  Map<String, dynamic> toJson() => _$DonationModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        requestId,
        donorId,
        amount,
        status,
        description,
        paymentMethod,
        transactionId,
        createdAt,
      ];

  DonationModel copyWith({
    int? id,
    int? requestId,
    String? donorId,
    double? amount,
    DonationStatus? status,
    String? description,
    String? paymentMethod,
    String? transactionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DonationModel(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      donorId: donorId ?? this.donorId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}