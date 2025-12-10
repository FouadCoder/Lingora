import 'package:lingora/features/favorites/domain/entities/favorite_entity.dart';
import 'package:lingora/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lingora/features/favorites/domain/usecases/favorites_params.dart';

class GetFavoritesUsecase {
  final FavoritesRepository favoritesRepository;

  GetFavoritesUsecase(this.favoritesRepository);

  Future<List<FavoriteEntity>> call(FavoritesParams params) {
    return favoritesRepository.getFavorites(params);
  }
}
