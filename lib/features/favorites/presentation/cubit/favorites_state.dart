import 'package:lingora/features/favorites/domain/entities/favorite_entity.dart';

enum FavoriteStatus {
  initial,
  loading,
  success,
  error,
}

enum FavoriteActionStatus {
  initial,
  loading,
  added,
  removed,
  error,
}

class FavoritesState {
  final FavoriteStatus status;
  final FavoriteActionStatus actionStatus;
  final List<FavoriteEntity> favorites;

  FavoritesState({
    this.status = FavoriteStatus.initial,
    this.actionStatus = FavoriteActionStatus.initial,
    this.favorites = const [],
  });

  FavoritesState copyWith({
    FavoriteStatus? status,
    FavoriteActionStatus? actionStatus,
    List<FavoriteEntity>? favorites,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      favorites: favorites ?? this.favorites,
    );
  }
}
