import 'package:lingora/features/favorites/domain/repositories/favorites_repositories.dart';
import 'package:lingora/features/favorites/domain/usecases/favorites_params.dart';

class RemoveFromFavoritesUsecase {
  final FavoritesRepositories favoritesRepositories;

  RemoveFromFavoritesUsecase(this.favoritesRepositories);

  Future<void> call(FavoritesParams params) {
    return favoritesRepositories.removeFromFavorites(params);
  }
}
