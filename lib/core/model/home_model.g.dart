// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModel _$HomeModelFromJson(Map<String, dynamic> json) => HomeModel(
      activeRequests: (json['active_requests'] as num).toInt(),
      pendingRequests: (json['pending_requests'] as num).toInt(),
      aidReceived: (json['aid_received'] as num).toInt(),
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$HomeModelToJson(HomeModel instance) => <String, dynamic>{
      'active_requests': instance.activeRequests,
      'pending_requests': instance.pendingRequests,
      'aid_received': instance.aidReceived,
      'last_updated': instance.lastUpdated?.toIso8601String(),
    };
