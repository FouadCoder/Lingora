import 'package:lingora/features/words/domain/entities/favorite_entity.dart';

enum FavoriteStatus {
  initial,
  loading,
  success,
  empty,
  error,
  networkError,
}

enum FavoriteActionStatus {
  idle,
  loading,
  added,
  removed,
  error,
  networkError,
}

class FavoritesState {
  final FavoriteStatus status;
  final FavoriteActionStatus actionStatus;
  final List<FavoriteEntity> favorites;
  final bool isLoadingMore;
  final bool hasMore;
  final int offset;
  final String? wordId;

  FavoritesState({
    this.status = FavoriteStatus.initial,
    this.actionStatus = FavoriteActionStatus.idle,
    this.favorites = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
    this.offset = 0,
    this.wordId,
  });

  FavoritesState copyWith({
    FavoriteStatus? status,
    FavoriteActionStatus? actionStatus,
    List<FavoriteEntity>? favorites,
    bool? isLoadingMore,
    bool? hasMore,
    int? offset,
    String? wordId,
  }) {
    return FavoritesState(
        status: status ?? this.status,
        actionStatus: actionStatus ?? this.actionStatus,
        favorites: favorites ?? this.favorites,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasMore: hasMore ?? this.hasMore,
        offset: offset ?? this.offset,
        wordId: wordId ?? this.wordId);
  }
}
