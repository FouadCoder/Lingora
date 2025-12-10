import 'package:lingora/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lingora/features/favorites/domain/usecases/favorites_params.dart';

class RemoveFromFavoritesUsecase {
  final FavoritesRepository favoritesRepository;

  RemoveFromFavoritesUsecase(this.favoritesRepository);

  Future<void> call(FavoritesParams params) {
    return favoritesRepository.removeFromFavorites(params);
  }
}
