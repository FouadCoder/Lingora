import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/settings/presentation/cubit/theme/theme_state.dart';

abstract class SettingsRepository {
  Future setLanguage(Language lang);
  Future<Language?> getLanguage();
  Future<Language?> getSystemLanguage();
  Future saveTheme(ThemeState theme);
  Future<ThemeState> getTheme();
  Future<ThemeState> getSystemTheme();
}
