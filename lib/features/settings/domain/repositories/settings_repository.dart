import 'package:lingora/data/langauges_list.dart';

abstract class SettingsRepository {
  Future setLanguage(Language lang);
  Future<Language?> getLanguage();
}
