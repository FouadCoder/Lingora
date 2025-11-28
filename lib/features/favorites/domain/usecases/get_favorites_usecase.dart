import 'package:lingora/features/favorites/domain/entities/favorite_entity.dart';
import 'package:lingora/features/favorites/domain/repositories/favorites_repositories.dart';
import 'package:lingora/features/favorites/domain/usecases/favorites_params.dart';

class GetFavoritesUsecase {
  final FavoritesRepositories favoritesRepositories;

  GetFavoritesUsecase(this.favoritesRepositories);

  Future<List<FavoriteEntity>> call(FavoritesParams params) {
    return favoritesRepositories.getFavorites(params);
  }
}
