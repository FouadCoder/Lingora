import 'package:lingora/features/analytics/data/models/daily_activity_model.dart';
import 'package:lingora/features/analytics/data/models/user_analytics_model.dart';
import 'package:lingora/features/analytics/domain/usecases/analytics_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Interface
abstract class AnalyticsRemoteData {
  Future<UserAnalyticsModel> getAnalytics();
  Future<List<DailyActivityModel>> getDailyActivitySummary(
      AnalyticsParams parms);
}

// Impl
class AnalyticsRemoteDataImpl implements AnalyticsRemoteData {
  final SupabaseClient supabaseClient;

  AnalyticsRemoteDataImpl(this.supabaseClient);

  @override
  Future<UserAnalyticsModel> getAnalytics() async {
    final userId = supabaseClient.auth.currentUser!.id;
    final response = await supabaseClient
        .from('user_analytics')
        .select('total_translations, total_library_words, active_days, xp')
        .eq('user_id', userId)
        .isFilter('deleted_at', null)
        .single();

    return UserAnalyticsModel.fromJson(response);
  }

  @override
  Future<List<DailyActivityModel>> getDailyActivitySummary(
      AnalyticsParams params) async {
    final response = await supabaseClient
        .from('daily_translation_summary')
        .select()
        .eq('user_id', params.userId);
    List<DailyActivityModel> dailyActivity =
        response.map((e) => DailyActivityModel.fromJson(e)).toList();
    return dailyActivity;
  }
}
