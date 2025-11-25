import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/settings/domain/repositories/settings_repository.dart';

class SaveLanguageUsecase {
  final SettingsRepository repository;

  SaveLanguageUsecase(this.repository);

  Future<void> call(Language language) async {
    return await repository.setLanguage(language);
  }
}
