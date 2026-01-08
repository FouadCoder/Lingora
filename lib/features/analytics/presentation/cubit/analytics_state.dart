import 'package:lingora/features/analytics/domain/entities/month_activity_entity.dart';
import 'package:lingora/features/analytics/domain/entities/user_analytics_entity.dart';

enum UserAnalyticsRequestStatus {
  initial,
  loading,
  success,
  failure,
  networkError
}

class UserAnalyticsState {
  final UserAnalyticsRequestStatus monthlyActivityStatus;
  final UserAnalyticsRequestStatus userAnalyticsStatus;
  final UserAnalyticsEntity? userAnalytics;
  final Map<int, List<MonthActivityEntity>>? monthlyActivity;
  final DateTime? lastMonthlyActivityDateFetch;
  final DateTime? lastUserAnalyticsDateFetch;

  const UserAnalyticsState({
    this.monthlyActivityStatus = UserAnalyticsRequestStatus.initial,
    this.userAnalyticsStatus = UserAnalyticsRequestStatus.initial,
    this.userAnalytics,
    this.monthlyActivity,
    this.lastMonthlyActivityDateFetch,
    this.lastUserAnalyticsDateFetch,
  });

  UserAnalyticsState copyWith({
    UserAnalyticsRequestStatus? monthlyActivityStatus,
    UserAnalyticsRequestStatus? userAnalyticsStatus,
    UserAnalyticsEntity? userAnalytics,
    Map<int, List<MonthActivityEntity>>? monthlyActivity,
    DateTime? lastMonthlyActivityDateFetch,
    DateTime? lastUserAnalyticsDateFetch,
  }) {
    return UserAnalyticsState(
      monthlyActivityStatus:
          monthlyActivityStatus ?? this.monthlyActivityStatus,
      userAnalyticsStatus: userAnalyticsStatus ?? this.userAnalyticsStatus,
      userAnalytics: userAnalytics ?? this.userAnalytics,
      monthlyActivity: monthlyActivity ?? this.monthlyActivity,
      lastMonthlyActivityDateFetch:
          lastMonthlyActivityDateFetch ?? this.lastMonthlyActivityDateFetch,
      lastUserAnalyticsDateFetch:
          lastUserAnalyticsDateFetch ?? this.lastUserAnalyticsDateFetch,
    );
  }
}
