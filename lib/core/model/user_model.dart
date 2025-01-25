import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatar;

  @JsonKey(name: 'user_role', defaultValue: UserRole.victim)
  final UserRole userRole;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.userRole,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  List<Object?> get props =>
      [id, name, email, avatar, userRole, createdAt, updatedAt];

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    UserRole? userRole,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      userRole: userRole ?? this.userRole,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonEnum()
enum UserRole {
  @JsonValue('victim')
  victim,

  @JsonValue('donor')
  donor,

  @JsonValue('admin')
  admin;
}
