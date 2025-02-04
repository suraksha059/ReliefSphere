// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonationModel _$DonationModelFromJson(Map<String, dynamic> json) =>
    DonationModel(
      id: (json['id'] as num?)?.toInt(),
      requestId: (json['request_id'] as num).toInt(),
      donorId: json['donor_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: $enumDecodeNullable(_$DonationStatusEnumMap, json['status']) ??
          DonationStatus.pending,
      description: json['description'] as String?,
      paymentMethod: json['payment_method'] as String,
      transactionId: json['transaction_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$DonationModelToJson(DonationModel instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'donor_id': instance.donorId,
      'amount': instance.amount,
      'status': _$DonationStatusEnumMap[instance.status]!,
      'description': instance.description,
      'payment_method': instance.paymentMethod,
      'transaction_id': instance.transactionId,
    };

const _$DonationStatusEnumMap = {
  DonationStatus.pending: 'pending',
  DonationStatus.completed: 'completed',
  DonationStatus.failed: 'failed',
  DonationStatus.refunded: 'refunded',
};
