import 'package:hive/hive.dart';
import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/settings/presentation/cubit/theme_state.dart';

class SettingsLocalData {
  final db = Hive.box("db");

  Future saveLanguage(Language lang) async {
    await db.put("language", lang.code);
  }

  Future<Language?> getLanguage() async {
    String langCode = await db.get("language", defaultValue: "en");
    return LanguageData.getLanguageByCode(langCode);
  }

  Future saveTheme(ThemeState them) async {
    await db.put("theme", them.name);
  }

  Future getTheme() async {
    String themeName = await db.get("theme", defaultValue: "dark");
    return ThemeState.values.firstWhere((element) => element.name == themeName);
  }
}
