class AuthEntity {
  final String? userId;
  final String? email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AuthEntity({
    this.userId,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  AuthEntity copyWith({
    String? userId,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuthEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
