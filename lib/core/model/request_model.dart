import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'request_model.g.dart';

@JsonSerializable()
class RequestModel extends Equatable {
  @JsonKey(includeToJson: false)
  final int? id;
  @JsonKey(name: 'type')
  final RequestType type;
  @JsonKey(name: 'urgency_level')
  final UrgencyLevel urgencyLevel;
  final String description;
  final double? lat;
  final double? long;
  final List<String>? images;
  @JsonKey(name: 'status', defaultValue: RequestStatus.pending)
  final RequestStatus status;
  @JsonKey(name: 'created_at', includeToJson: false)
  final DateTime? date;
  final String? address;
  final String title;

  const RequestModel({
    this.id,
    required this.type,
    required this.urgencyLevel,
    required this.description,
    this.lat,
    this.long,
    this.images,
    this.status = RequestStatus.pending,
    this.date,
    this.address,
    required this.title,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) =>
      _$RequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        type,
        urgencyLevel,
        description,
        lat,
        long,
        images,
        status,
        date,
        address,
        title,
      ];

  RequestModel copyWith({
    int? id,
    RequestType? type,
    UrgencyLevel? urgencyLevel,
    String? description,
    double? lat,
    double? long,
    List<String>? images,
    RequestStatus? status,
    DateTime? date,
    String? address,
    String? title,
  }) {
    return RequestModel(
      id: id ?? this.id,
      type: type ?? this.type,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      description: description ?? this.description,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      images: images ?? this.images,
      status: status ?? this.status,
      date: date ?? this.date,
      address: address ?? this.address,
      title: title ?? this.title,
    );
  }
}

@JsonEnum(valueField: 'value')
enum UrgencyLevel {
  low('low'),
  moderate('moderate'),
  high('high'),
  veryHigh('very_high'),
  critical('critical');

  final String value;
  const UrgencyLevel(this.value);
}

@JsonEnum(valueField: 'value')
enum RequestType {
  foodAndEssentials('food_and_essentials'),
  medicalAid('medical_aid'),
  shelter('shelter'),
  clothing('clothing'),
  utilities('utilities'),
  other('other');

  final String value;
  const RequestType(this.value);
}

@JsonEnum(valueField: 'value')
enum RequestStatus {
  pending('pending'),
  approved('approved'),
  inProgress('in_progress'),
  rejected('rejected'),
  completed('completed'),
  cancelled('cancelled');

  final String value;
  const RequestStatus(this.value);
}
