import 'package:lingora/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> logout();
  Future<AuthEntity?> checkSession();
  Future<void> createProfile();
}
