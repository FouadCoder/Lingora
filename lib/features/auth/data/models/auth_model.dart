import 'package:lingora/features/auth/domain/entities/auth_entity.dart';

class AuthModel {
  final String? userId;
  final String? email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AuthModel({
    this.userId,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      userId: json['user_id'],
      email: json['email'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
