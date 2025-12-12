import 'package:lingora/features/words/domain/repositories/library_repository.dart';
import 'package:lingora/features/words/domain/usecases/params/favorites_params.dart';

class AddToFavoritesUsecase {
  final LibraryRepository libraryRepository;

  AddToFavoritesUsecase(this.libraryRepository);

  get favoritesRepository => null;

  Future<void> call(FavoritesParams params) {
    return favoritesRepository.addToFavorites(params);
  }
}
