import 'package:lingora/features/auth/domain/repositories/auth_repository.dart';

class CreateProfileUseCase {
  final AuthRepository repository;

  CreateProfileUseCase(this.repository);

  Future<void> call() {
    return repository.createProfile();
  }
}
