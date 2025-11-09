import 'package:lingora/features/analytics/domain/entities/daily_activity_entity.dart';
import 'package:lingora/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:lingora/features/analytics/domain/usecases/analytics_params.dart';

class GetDailyActivityUsercase {
  final AnalyticsRepository analyticsRepository;

  GetDailyActivityUsercase(this.analyticsRepository);

  Future<List<DailyActivityEntity>> call(AnalyticsParams params) async {
    return analyticsRepository.getDailyActivitySummary(params);
  }
}
