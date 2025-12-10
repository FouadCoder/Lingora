import 'package:lingora/features/analytics/domain/entities/daily_activity_entity.dart';

class MonthActivityEntity {
  final int activeDays;
  final int totalTranslations;
  final List<DailyActivityEntity> dailyActivities;

  MonthActivityEntity({
    required this.activeDays,
    required this.totalTranslations,
    required this.dailyActivities,
  });
}
