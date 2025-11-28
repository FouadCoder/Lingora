import 'package:lingora/features/favorites/domain/entities/favorite_entity.dart';
import 'package:lingora/features/favorites/domain/usecases/favorites_params.dart';

abstract class FavoritesRepositories {
  Future<List<FavoriteEntity>> getFavorites(FavoritesParams params);
  Future<void> addToFavorites(FavoritesParams params);
  Future<void> removeFromFavorites(FavoritesParams params);
}
