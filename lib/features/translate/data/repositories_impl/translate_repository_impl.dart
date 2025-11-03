import 'package:lingora/features/translate/data/datasources/translate_remote_data.dart';
import 'package:lingora/features/translate/domain/entities/translate_entity.dart';
import 'package:lingora/features/translate/domain/repositories/translate_repository.dart';
import 'package:lingora/features/translate/domain/usecases/translate_params.dart';

class TranslateRepositoryImpl implements TranslateRepository {
  final TranslateRemoteData translateRemoteData;

  TranslateRepositoryImpl(this.translateRemoteData);
  @override
  Future<TranslateEntity> translate(TranslateParams params) async {
    final model = await translateRemoteData.translate(params);
    return model.toEntity();
  }
}
