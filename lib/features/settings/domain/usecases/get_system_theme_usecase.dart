import 'package:lingora/features/settings/domain/repositories/settings_repository.dart';
import 'package:lingora/features/settings/presentation/cubit/theme/theme_state.dart';

class GetSystemThemeUsecase {
  final SettingsRepository settingsRepository;

  GetSystemThemeUsecase(this.settingsRepository);

  Future<ThemeState> call() async {
    return await settingsRepository.getSystemTheme();
  }
}
