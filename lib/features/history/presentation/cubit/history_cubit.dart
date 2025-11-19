// History
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/history/domain/entities/history_entity.dart';
import 'package:lingora/features/history/domain/usecases/fetch_history_usecase.dart';
import 'package:lingora/features/history/domain/usecases/history_params.dart';
import 'package:lingora/features/history/presentation/cubit/history_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryCubit extends Cubit<FetchHistoryState> {
  final SupabaseClient supabaseClient;
  final FetchHistoryUseCase fetchHistoryUseCase;
  HistoryCubit(this.supabaseClient, this.fetchHistoryUseCase)
      : super(FetchHistoryState());

  // Fetch history
  Future<void> fetchHistory() async {
    try {
      emit(state.copyWith(status: FetchHistoryStatus.loading));

      // Get history
      final userId = supabaseClient.auth.currentUser!.id;
      final Map<String, List<HistoryEntity>> history =
          await fetchHistoryUseCase.call(HistoryParams(userId: userId));

      print("History data =============== $history");

      // Success
      emit(
          state.copyWith(status: FetchHistoryStatus.success, history: history));
    } catch (e) {
      print("Error getting history ------------------ $e");
      emit(state.copyWith(status: FetchHistoryStatus.failure));
    }
  }
}
