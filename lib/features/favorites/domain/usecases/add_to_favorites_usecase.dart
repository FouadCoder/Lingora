import 'package:lingora/features/favorites/domain/repositories/favorites_repositories.dart';
import 'package:lingora/features/favorites/domain/usecases/favorites_params.dart';

class AddToFavoritesUsecase {
  final FavoritesRepositories favoritesRepositories;

  AddToFavoritesUsecase(this.favoritesRepositories);

  Future<void> call(FavoritesParams params) {
    return favoritesRepositories.addToFavorites(params);
  }
}
