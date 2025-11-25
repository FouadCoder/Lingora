import 'package:lingora/features/settings/domain/repositories/settings_repository.dart';
import 'package:lingora/features/settings/presentation/cubit/theme_state.dart';

class GetThemeUsecase {
  final SettingsRepository settingsRepository;

  GetThemeUsecase(this.settingsRepository);

  Future<ThemeState> call() async {
    return await settingsRepository.getTheme();
  }
}
