// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestModel _$RequestModelFromJson(Map<String, dynamic> json) => RequestModel(
      id: (json['id'] as num?)?.toInt(),
      type: $enumDecode(_$RequestTypeEnumMap, json['type']),
      urgencyLevel: $enumDecode(_$UrgencyLevelEnumMap, json['urgency_level']),
      description: json['description'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      long: (json['long'] as num?)?.toDouble(),
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      status: $enumDecodeNullable(_$RequestStatusEnumMap, json['status']) ??
          RequestStatus.pending,
      date: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      address: json['address'] as String?,
      title: json['title'] as String,
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RequestModelToJson(RequestModel instance) =>
    <String, dynamic>{
      'type': _$RequestTypeEnumMap[instance.type]!,
      'urgency_level': _$UrgencyLevelEnumMap[instance.urgencyLevel]!,
      'description': instance.description,
      'lat': instance.lat,
      'long': instance.long,
      'images': instance.images,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'address': instance.address,
      'title': instance.title,
      'distance': instance.distance,
    };

const _$RequestTypeEnumMap = {
  RequestType.foodAndEssentials: 'food_and_essentials',
  RequestType.medicalAid: 'medical_aid',
  RequestType.shelter: 'shelter',
  RequestType.clothing: 'clothing',
  RequestType.utilities: 'utilities',
  RequestType.other: 'other',
};

const _$UrgencyLevelEnumMap = {
  UrgencyLevel.low: 'low',
  UrgencyLevel.moderate: 'moderate',
  UrgencyLevel.high: 'high',
  UrgencyLevel.veryHigh: 'very_high',
  UrgencyLevel.critical: 'critical',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.approved: 'approved',
  RequestStatus.inProgress: 'in_progress',
  RequestStatus.rejected: 'rejected',
  RequestStatus.completed: 'completed',
  RequestStatus.cancelled: 'cancelled',
};
