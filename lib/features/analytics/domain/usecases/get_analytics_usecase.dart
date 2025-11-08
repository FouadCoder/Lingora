import 'package:lingora/features/analytics/domain/entities/user_analytics_entity.dart';
import 'package:lingora/features/analytics/domain/repositories/analytics_repository.dart';

class GetAnalyticsUsecase {
  final AnalyticsRepository repository;

  GetAnalyticsUsecase(this.repository);

  Future<UserAnalyticsEntity> call() async {
    return await repository.getAnalytics();
  }
}
