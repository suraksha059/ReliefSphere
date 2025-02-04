import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel extends Equatable {
  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final String? state;
  final String? country;
  @JsonKey(name: 'postal_code')
  final String? postalCode;

  const AddressModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        address,
        city,
        state,
        country,
        postalCode,
      ];

  AddressModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
  }) {
    return AddressModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
    );
  }
}
