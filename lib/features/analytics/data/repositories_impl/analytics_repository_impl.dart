import 'package:lingora/features/analytics/data/datasources/analytics_remote_data.dart';
import 'package:lingora/features/analytics/domain/entities/user_analytics_entity.dart';
import 'package:lingora/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteData analyticsRemoteData;

  AnalyticsRepositoryImpl(this.analyticsRemoteData);

  @override
  Future<UserAnalyticsEntity> getAnalytics() async {
    final model = await analyticsRemoteData.getAnalytics();
    return model.toEnitity();
  }
}
