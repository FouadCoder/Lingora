import 'package:lingora/features/analytics/domain/entities/user_analytics_entity.dart';

enum UserAnalyticsStatus { initial, loading, success, failure }

class UserAnalyticsState {
  final UserAnalyticsStatus status;
  final UserAnalyticsEntity? userAnalytics;

  const UserAnalyticsState({
    this.status = UserAnalyticsStatus.initial,
    this.userAnalytics,
  });

  UserAnalyticsState copyWith({
    UserAnalyticsStatus? status,
    UserAnalyticsEntity? userAnalytics,
  }) {
    return UserAnalyticsState(
      status: status ?? this.status,
      userAnalytics: userAnalytics ?? this.userAnalytics,
    );
  }
}
