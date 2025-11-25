import 'package:lingora/features/settings/domain/repositories/settings_repository.dart';
import 'package:lingora/features/settings/presentation/cubit/theme_state.dart';

class SetThemeUsecase {
  final SettingsRepository settingsRepository;

  SetThemeUsecase(this.settingsRepository);

  Future<void> call(ThemeState themeState) async {
    await settingsRepository.saveTheme(themeState);
  }
}
