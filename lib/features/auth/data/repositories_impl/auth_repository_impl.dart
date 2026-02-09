import 'package:lingora/core/exceptions/network_exception.dart';
import 'package:lingora/core/service/network_service.dart';
import 'package:lingora/features/auth/data/datasources/auth_remote_data.dart';
import 'package:lingora/features/auth/domain/entities/auth_entity.dart';
import 'package:lingora/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteData remoteData;

  AuthRepositoryImpl(this.remoteData);

  @override
  Future<void> login(String email, String password) async {
    // Check network
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    await remoteData.login(email, password);
  }

  @override
  Future<void> signUp(String email, String password) async {
    // Check network
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    await remoteData.signUp(email, password);
  }

  @override
  Future<void> logout() async {
    // Check network
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    await remoteData.logout();
  }

  @override
  Future<AuthEntity?> checkSession() async {
    final authModel = await remoteData.checkSession();
    return authModel?.toEntity();
  }
}
