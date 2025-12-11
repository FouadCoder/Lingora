import 'package:easy_localization/easy_localization.dart';
import 'package:lingora/features/analytics/domain/entities/daily_activity_entity.dart';
import 'package:lingora/features/analytics/domain/entities/month_activity_entity.dart';
import 'package:lingora/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:lingora/features/analytics/domain/usecases/analytics_params.dart';

class GetDailyActivityUsercase {
  final AnalyticsRepository analyticsRepository;

  GetDailyActivityUsercase(this.analyticsRepository);

  Future<Map<int, List<MonthActivityEntity>>> call(
      AnalyticsParams params) async {
    final data = await analyticsRepository.getDailyActivitySummary(params);

    // year → month → list of DailyActivityEntity
    final Map<int, Map<String, List<DailyActivityEntity>>> grouped = {};

    for (var element in data) {
      final year = element.date.year;
      final monthName =
          DateFormat.MMMM().format(element.date); // January, February...

      grouped[year] ??= {};
      grouped[year]![monthName] ??= [];
      grouped[year]![monthName]!.add(element);
    }

    // Now convert to MonthActivityEntity structure
    final Map<int, List<MonthActivityEntity>> result = {};

    grouped.forEach((year, monthsMap) {
      result[year] = monthsMap.entries.map((entry) {
        final month = entry.key;
        final dailyActivities = entry.value;

        return MonthActivityEntity(
          month: month,
          activeDays: dailyActivities.length,
          totalTranslations:
              dailyActivities.fold(0, (sum, e) => sum + e.totalTranslations),
          dailyActivities: dailyActivities,
        );
      }).toList();
    });

    return result;
  }
}
