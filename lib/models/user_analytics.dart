import 'package:lingora/models/level.dart';

class UserAnalytics {
  final int totalTranslations;
  final int totalLibraryWords;
  final int activeDays;
  final Level level;

  UserAnalytics({
    required this.totalTranslations,
    required this.totalLibraryWords,
    required this.activeDays,
    required this.level,
  });

  factory UserAnalytics.fromJson(Map<String, dynamic> json) {
    return UserAnalytics(
      totalTranslations: json['total_translations'] ?? 0,
      totalLibraryWords: json['total_library_words'] ?? 0,
      activeDays: json['active_days'] ?? 0,
      level: Level.getUserLevel(json['xp'] ?? 0),
    );
  }
}
