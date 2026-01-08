import 'package:lingora/core/exceptions/network_exception.dart';
import 'package:lingora/core/service/network_service.dart';
import 'package:lingora/features/analytics/data/datasources/analytics_remote_data.dart';
import 'package:lingora/features/analytics/domain/entities/daily_activity_entity.dart';
import 'package:lingora/features/analytics/domain/entities/user_analytics_entity.dart';
import 'package:lingora/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteData analyticsRemoteData;

  AnalyticsRepositoryImpl(this.analyticsRemoteData);

  @override
  Future<UserAnalyticsEntity> getAnalytics() async {
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    // Call
    final model = await analyticsRemoteData.getAnalytics();
    return model.toEnitity();
  }

  @override
  Future<List<DailyActivityEntity>> getDailyActivitySummary() async {
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    // Call
    final model = await analyticsRemoteData.getDailyActivitySummary();
    List<DailyActivityEntity> dailyActivity =
        model.map((e) => e.toEntity()).toList();
    return dailyActivity;
  }
}
