import 'package:lingora/features/analytics/data/models/user_analytics_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsRemoteData {
  final SupabaseClient supabaseClient;

  AnalyticsRemoteData(this.supabaseClient);

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
}
