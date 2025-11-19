import 'package:lingora/features/history/data/models/history_model.dart';
import 'package:lingora/features/history/domain/usecases/history_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryRemoteData {
  final SupabaseClient supabaseClient;

  HistoryRemoteData(this.supabaseClient);
  Future fetchHistory(HistoryParams params) async {
    final res = await supabaseClient
        .from("translate_history")
        .select()
        .eq("user_id", params.userId)
        .isFilter('deleted_at', null)
        .order('created_at', ascending: false)
        .range(params.offset, params.offset + 15 - 1);

    List<HistoryModel> historyModels =
        res.map((e) => HistoryModel.fromJson(e)).toList();

    return historyModels;
  }
}
