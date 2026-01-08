import 'package:lingora/features/history/domain/entities/history_entity.dart';

enum FetchHistoryStatus {
  initial,
  loading,
  success,
  failure,
  empty,
  networkError
}

class FetchHistoryState {
  final FetchHistoryStatus status;
  final Map<String, List<HistoryEntity>> history;
  final bool hasMore;
  final bool isLoadingMore;

  const FetchHistoryState(
      {this.status = FetchHistoryStatus.initial,
      this.history = const {},
      this.hasMore = false,
      this.isLoadingMore = false});

  FetchHistoryState copyWith({
    FetchHistoryStatus? status,
    Map<String, List<HistoryEntity>>? history,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return FetchHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
