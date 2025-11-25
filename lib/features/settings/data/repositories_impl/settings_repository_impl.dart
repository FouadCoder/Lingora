import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/settings/data/datasources/settings_local_data.dart';
import 'package:lingora/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalData localData;

  SettingsRepositoryImpl(this.localData);

  @override
  Future setLanguage(Language lang) async {
    return await localData.saveLanguage(lang);
  }

  @override
  Future<Language?> getLanguage() async {
    return await localData.getLanguage();
  }
}
