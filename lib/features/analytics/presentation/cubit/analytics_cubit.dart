import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/analytics/domain/usecases/get_analytics_usecase.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsCubit extends Cubit<UserAnalyticsState> {
  final SupabaseClient supabaseClient;
  final GetAnalyticsUsecase getAnalyticsUsecase;
  AnalyticsCubit(this.supabaseClient, this.getAnalyticsUsecase)
      : super(const UserAnalyticsState());

  // Get analysis
  Future<void> getAnalysis() async {
    try {
      emit(state.copyWith(status: UserAnalyticsStatus.loading));

      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(status: UserAnalyticsStatus.failure));
        return;
      }
      // Get analytics
      final analytics = await getAnalyticsUsecase.call();
      emit(state.copyWith(
        status: UserAnalyticsStatus.success,
        userAnalytics: analytics,
      ));
    } catch (e) {
      print("=========== Error getting analytics: $e");
      emit(state.copyWith(status: UserAnalyticsStatus.failure));
    }
  }
}
