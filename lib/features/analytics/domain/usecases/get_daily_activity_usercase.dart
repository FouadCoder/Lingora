import 'package:easy_localization/easy_localization.dart';
import 'package:lingora/features/analytics/domain/entities/daily_activity_entity.dart';
import 'package:lingora/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:lingora/features/analytics/domain/usecases/analytics_params.dart';

class GetDailyActivityUsercase {
  final AnalyticsRepository analyticsRepository;

  GetDailyActivityUsercase(this.analyticsRepository);

  Future<Map<int, Map<String, List<DailyActivityEntity>>>> call(
      AnalyticsParams params) async {
    final data = await analyticsRepository.getDailyActivitySummary(params);

    // Filter by date
    Map<int, Map<String, List<DailyActivityEntity>>> grouped = {};
    for (var element in data) {
      final year = element.date.year;
      final monthName = DateFormat.MMM().format(element.date); // Jan, Feb, etc.

      // Check
      grouped[year] ??= {};
      grouped[year]![monthName] ??= [];
      grouped[year]![monthName]!.add(element);
    }

    print("Data ----------------------------------- $grouped");

    return grouped;
  }
}
