import 'package:hive/hive.dart';
import 'package:lingora/data/langauges_list.dart';

class SettingsLocalData {
  final db = Hive.box("db");

  Future saveLanguage(Language lang) async {
    await db.put("language", lang.code);
  }

  Future<Language?> getLanguage() async {
    String langCode = await db.get("language", defaultValue: "en");
    return LanguageData.getLanguageByCode(langCode);
  }
}
