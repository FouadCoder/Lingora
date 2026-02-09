import 'package:lingora/features/auth/domain/entities/auth_entity.dart';
import 'package:lingora/features/auth/domain/repositories/auth_repository.dart';

class CheckSessionUseCase {
  final AuthRepository repository;

  CheckSessionUseCase(this.repository);

  Future<AuthEntity?> call() {
    return repository.checkSession();
  }
}
