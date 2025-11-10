import 'package:lingora/features/analytics/domain/entities/daily_activity_entity.dart';
import 'package:lingora/features/analytics/domain/entities/user_analytics_entity.dart';

enum UserAnalyticsRequestStatus { initial, loading, success, failure }

class UserAnalyticsState {
  final UserAnalyticsRequestStatus dailyActivityStatus;
  final UserAnalyticsRequestStatus userAnalyticsStatus;
  final UserAnalyticsEntity? userAnalytics;
  final Map<int, Map<String, List<DailyActivityEntity>>>? dailyActivity;
  const UserAnalyticsState({
    this.dailyActivityStatus = UserAnalyticsRequestStatus.initial,
    this.userAnalyticsStatus = UserAnalyticsRequestStatus.initial,
    this.userAnalytics,
    this.dailyActivity,
  });

  UserAnalyticsState copyWith({
    UserAnalyticsRequestStatus? dailyActivityStatus,
    UserAnalyticsRequestStatus? userAnalyticsStatus,
    UserAnalyticsEntity? userAnalytics,
    Map<int, Map<String, List<DailyActivityEntity>>>? dailyActivity,
  }) {
    return UserAnalyticsState(
      dailyActivityStatus: dailyActivityStatus ?? this.dailyActivityStatus,
      userAnalyticsStatus: userAnalyticsStatus ?? this.userAnalyticsStatus,
      userAnalytics: userAnalytics ?? this.userAnalytics,
      dailyActivity: dailyActivity ?? this.dailyActivity,
    );
  }
}
