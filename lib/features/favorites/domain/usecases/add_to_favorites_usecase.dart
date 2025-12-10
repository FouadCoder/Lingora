import 'package:lingora/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lingora/features/favorites/domain/usecases/favorites_params.dart';

class AddToFavoritesUsecase {
  final FavoritesRepository favoritesRepository;

  AddToFavoritesUsecase(this.favoritesRepository);

  Future<void> call(FavoritesParams params) {
    return favoritesRepository.addToFavorites(params);
  }
}
