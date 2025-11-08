import 'package:lingora/models/level.dart';

class UserAnalyticsEntity {
  final int totalTranslations;
  final int totalLibraryWords;
  final int activeDays;
  final Level level;

  UserAnalyticsEntity({
    required this.totalTranslations,
    required this.totalLibraryWords,
    required this.activeDays,
    required this.level,
  });
}
