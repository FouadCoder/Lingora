import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/analytics/domain/usecases/analytics_params.dart';
import 'package:lingora/features/analytics/domain/usecases/get_analytics_usecase.dart';
import 'package:lingora/features/analytics/domain/usecases/get_daily_activity_usercase.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsCubit extends Cubit<UserAnalyticsState> {
  final SupabaseClient supabaseClient;
  final GetAnalyticsUsecase getAnalyticsUsecase;
  final GetDailyActivityUsercase getDailyActivitySummaryUsecase;
  AnalyticsCubit(this.supabaseClient, this.getAnalyticsUsecase,
      this.getDailyActivitySummaryUsecase)
      : super(const UserAnalyticsState());

  // Get analysis
  Future<void> getAnalysis() async {
    try {
      // If data exist on memory
      if (state.lastUserAnalyticsDateFetch != null) {
        emit(state.copyWith(
          userAnalyticsStatus: UserAnalyticsRequestStatus.success,
          userAnalytics: state.userAnalytics,
        ));
        return;
      }

      // Loading
      emit(state.copyWith(
          userAnalyticsStatus: UserAnalyticsRequestStatus.loading));

      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(
            userAnalyticsStatus: UserAnalyticsRequestStatus.failure));
        return;
      }
      // Get analytics
      final analytics = await getAnalyticsUsecase.call();

      emit(state.copyWith(
          userAnalyticsStatus: UserAnalyticsRequestStatus.success,
          userAnalytics: analytics,
          lastUserAnalyticsDateFetch: DateTime.now()));
    } catch (e) {
      emit(state.copyWith(
          userAnalyticsStatus: UserAnalyticsRequestStatus.failure));
    }
  }

  // Get daily activity summary
  Future<void> getDailyActivitySummary() async {
    try {
      // If data exist on memory
      if (state.lastMonthlyActivityDateFetch != null) {
        emit(state.copyWith(
          monthlyActivityStatus: UserAnalyticsRequestStatus.success,
          monthlyActivity: state.monthlyActivity,
        ));
        return;
      }
      emit(state.copyWith(
          monthlyActivityStatus: UserAnalyticsRequestStatus.loading));

      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(
            monthlyActivityStatus: UserAnalyticsRequestStatus.failure));
        return;
      }

      // Get daily activity summary
      final dailyActivitySummary = await getDailyActivitySummaryUsecase
          .call(AnalyticsParams(userId: userId));

      emit(state.copyWith(
        monthlyActivityStatus: UserAnalyticsRequestStatus.success,
        monthlyActivity: dailyActivitySummary,
        lastMonthlyActivityDateFetch: DateTime.now(),
      ));
    } catch (e) {
      emit(state.copyWith(
          monthlyActivityStatus: UserAnalyticsRequestStatus.failure));
    }
  }
}
