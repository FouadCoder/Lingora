import 'package:lingora/features/analytics/domain/entities/daily_activity_entity.dart';
import 'package:lingora/features/analytics/domain/entities/user_analytics_entity.dart';

abstract class AnalyticsRepository {
  Future<UserAnalyticsEntity> getAnalytics();
  Future<List<DailyActivityEntity>> getDailyActivitySummary();
}
