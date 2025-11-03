import 'package:lingora/features/translate/domain/entities/translate_entity.dart';
import 'package:lingora/features/translate/domain/repositories/translate_repository.dart';
import 'package:lingora/features/translate/domain/usecases/translate_params.dart';

class TranslateUsecase {
  final TranslateRepository repository;

  TranslateUsecase(this.repository);

  Future<TranslateEntity> call(TranslateParams params) async {
    return await repository.translate(params);
  }
}
