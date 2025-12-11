import 'package:lingora/features/analytics/domain/entities/month_activity_entity.dart';
import 'package:lingora/features/analytics/domain/entities/user_analytics_entity.dart';

enum UserAnalyticsRequestStatus { initial, loading, success, failure }

class UserAnalyticsState {
  final UserAnalyticsRequestStatus dailyActivityStatus;
  final UserAnalyticsRequestStatus userAnalyticsStatus;
  final UserAnalyticsEntity? userAnalytics;
  final Map<int, List<MonthActivityEntity>>? dailyActivity;
  final DateTime? lastDailyActivityDateFetch;
  final DateTime? lastUserAnalyticsDateFetch;
  const UserAnalyticsState(
      {this.dailyActivityStatus = UserAnalyticsRequestStatus.initial,
      this.userAnalyticsStatus = UserAnalyticsRequestStatus.initial,
      this.userAnalytics,
      this.dailyActivity,
      this.lastDailyActivityDateFetch,
      this.lastUserAnalyticsDateFetch});

  UserAnalyticsState copyWith({
    UserAnalyticsRequestStatus? dailyActivityStatus,
    UserAnalyticsRequestStatus? userAnalyticsStatus,
    UserAnalyticsEntity? userAnalytics,
    Map<int, List<MonthActivityEntity>>? dailyActivity,
    DateTime? lastDailyActivityDateFetch,
    DateTime? lastUserAnalyticsDateFetch,
  }) {
    return UserAnalyticsState(
      dailyActivityStatus: dailyActivityStatus ?? this.dailyActivityStatus,
      userAnalyticsStatus: userAnalyticsStatus ?? this.userAnalyticsStatus,
      userAnalytics: userAnalytics ?? this.userAnalytics,
      dailyActivity: dailyActivity ?? this.dailyActivity,
      lastDailyActivityDateFetch:
          lastDailyActivityDateFetch ?? this.lastDailyActivityDateFetch,
      lastUserAnalyticsDateFetch:
          lastUserAnalyticsDateFetch ?? this.lastUserAnalyticsDateFetch,
    );
  }
}
