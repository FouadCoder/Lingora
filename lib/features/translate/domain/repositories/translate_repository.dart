import 'package:lingora/features/translate/domain/entities/translate_entity.dart';
import 'package:lingora/features/translate/domain/usecases/translate_params.dart';

abstract class TranslateRepository {
  Future<TranslateEntity> translate(TranslateParams params);
}
