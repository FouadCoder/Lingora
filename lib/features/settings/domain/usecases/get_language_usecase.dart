import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/settings/domain/repositories/settings_repository.dart';

class GetLanguageUsecase {
  final SettingsRepository repository;

  GetLanguageUsecase(this.repository);

  Future<Language?> call() async {
    if (await repository.getLanguage() == null) {
      return LanguageData.getLanguageByCode("en");
    }
    return await repository.getLanguage();
  }
}
