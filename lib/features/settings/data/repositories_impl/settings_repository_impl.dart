import 'package:flutter/cupertino.dart';
import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/settings/data/datasources/settings_local_data.dart';
import 'package:lingora/features/settings/domain/repositories/settings_repository.dart';
import 'package:lingora/features/settings/presentation/cubit/theme/theme_state.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalData localData;

  SettingsRepositoryImpl(this.localData);

  // Language

  @override
  Future setLanguage(Language lang) async {
    return await localData.saveLanguage(lang);
  }

  @override
  Future<Language?> getLanguage() async {
    return await localData.getLanguage();
  }

  @override
  Future<Language?> getSystemLanguage() async {
    Locale systemLang = await localData.getSystemLanguage();
    Language? language =
        LanguageData.getLanguageByCode(systemLang.languageCode);

    return language;
  }

  // Theme

  @override
  Future saveTheme(ThemeState theme) async {
    return await localData.saveTheme(theme);
  }

  @override
  Future<ThemeState> getTheme() async {
    return await localData.getTheme();
  }

  @override
  Future<ThemeState> getSystemTheme() async {
    return localData.getSystemTheme();
  }
}
