import 'package:lingora/features/analytics/domain/entities/daily_activity_entity.dart';
import 'package:lingora/features/analytics/domain/entities/month_activity_entity.dart';
import 'package:lingora/features/analytics/domain/repositories/analytics_repository.dart';

class GetDailyActivityUsercase {
  final AnalyticsRepository analyticsRepository;

  GetDailyActivityUsercase(this.analyticsRepository);

  Future<Map<int, List<MonthActivityEntity>>> call() async {
    final rawData = await analyticsRepository.getDailyActivitySummary();

    // Group by year → month
    final Map<int, Map<int, List<DailyActivityEntity>>> grouped = {};
    for (var item in rawData) {
      final year = item.date.year;
      final month = item.date.month;
      grouped[year] ??= {};
      grouped[year]![month] ??= [];
      grouped[year]![month]!.add(item);
    }

    // Ensure all 12 months exist
    final Map<int, List<MonthActivityEntity>> result = {};
    grouped.forEach((year, monthsMap) {
      result[year] = List.generate(12, (i) {
        final monthNum = i + 1;
        final dailyActivities = monthsMap[monthNum] ?? [];
        return MonthActivityEntity(
          month: DateTime(year, monthNum),
          activeDays: dailyActivities.length,
          totalTranslations:
              dailyActivities.fold(0, (sum, e) => sum + e.totalTranslations),
          dailyActivities: dailyActivities,
        );
      });
    });

    return result;
  }
}
