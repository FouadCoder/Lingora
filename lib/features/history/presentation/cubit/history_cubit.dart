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

  int _offset = 0;

  // Load more
  Future loadMoreHistory() async {
    // If there no more to load
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      // Get history
      final userId = supabaseClient.auth.currentUser!.id;
      final Map<String, List<HistoryEntity>> history = await fetchHistoryUseCase
          .call(HistoryParams(userId: userId, offset: _offset));

      // Update offset
      int itemCount = history.values.fold(0, (sum, list) => sum + list.length);
      _offset += itemCount;
      bool hasMore = itemCount == 15;

      // Success
      emit(state.copyWith(
          status: FetchHistoryStatus.success,
          history: {...state.history, ...history},
          hasMore: hasMore,
          isLoadingMore: false));
    } catch (e) {
      emit(state.copyWith(status: FetchHistoryStatus.failure));
    }
  }

  // Fetch history
  Future<void> fetchHistory() async {
    try {
      // If already loaded
      if (state.history.isNotEmpty) {
        emit(state.copyWith(
            status: FetchHistoryStatus.success, history: state.history));
        return;
      }

      emit(state.copyWith(status: FetchHistoryStatus.loading));

      // Get history
      final userId = supabaseClient.auth.currentUser!.id;
      final Map<String, List<HistoryEntity>> history = await fetchHistoryUseCase
          .call(HistoryParams(userId: userId, offset: 0));

      // Update offset
      int itemCount = history.values.fold(0, (sum, list) => sum + list.length);
      _offset += itemCount;
      bool hasMore = itemCount == 15;

      // Success
      emit(state.copyWith(
          status: FetchHistoryStatus.success,
          history: history,
          hasMore: hasMore));
    } catch (e) {
      emit(state.copyWith(status: FetchHistoryStatus.failure));
    }
  }
}
