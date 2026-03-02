import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/settings/domain/repositories/settings_repository.dart';

class GetSystemLanguageUsecase {
  final SettingsRepository settingsRepository;

  GetSystemLanguageUsecase(this.settingsRepository);

  Future<Language?> call() async {
    return await settingsRepository.getSystemLanguage();
  }
}
