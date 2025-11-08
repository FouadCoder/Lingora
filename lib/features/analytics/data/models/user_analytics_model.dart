import 'package:lingora/features/analytics/domain/entities/user_analytics_entity.dart';
import 'package:lingora/models/level.dart';

class UserAnalyticsModel {
  final int totalTranslations;
  final int totalLibraryWords;
  final int activeDays;
  final Level level;

  UserAnalyticsModel({
    required this.totalTranslations,
    required this.totalLibraryWords,
    required this.activeDays,
    required this.level,
  });

  factory UserAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return UserAnalyticsModel(
      totalTranslations: json['total_translations'] ?? 0,
      totalLibraryWords: json['total_library_words'] ?? 0,
      activeDays: json['active_days'] ?? 0,
      level: Level.getUserLevel(json['xp'] ?? 0),
    );
  }

  // to Entity
  UserAnalyticsEntity toEnitity() => UserAnalyticsEntity(
        totalTranslations: totalTranslations,
        totalLibraryWords: totalLibraryWords,
        activeDays: activeDays,
        level: level,
      );
}
