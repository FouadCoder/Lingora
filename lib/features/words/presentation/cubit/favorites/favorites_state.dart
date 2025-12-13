import 'package:lingora/features/words/domain/entities/favorite_entity.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';

enum FavoriteStatus {
  initial,
  loading,
  success,
  empty,
  error,
}

enum FavoriteActionStatus {
  idle,
  loading,
  added,
  removed,
  error,
}

class FavoritesState {
  final FavoriteStatus status;
  final FavoriteActionStatus actionStatus;
  final List<FavoriteEntity> favorites;
  final WordEntity? word;
  final bool isLoadingMore;
  final bool hasMore;
  final int offset;

  FavoritesState({
    this.status = FavoriteStatus.initial,
    this.actionStatus = FavoriteActionStatus.idle,
    this.favorites = const [],
    this.word,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.offset = 0,
  });

  FavoritesState copyWith({
    FavoriteStatus? status,
    FavoriteActionStatus? actionStatus,
    List<FavoriteEntity>? favorites,
    WordEntity? word,
    bool? isLoadingMore,
    bool? hasMore,
    int? offset,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      favorites: favorites ?? this.favorites,
      word: word ?? this.word,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
    );
  }
}
