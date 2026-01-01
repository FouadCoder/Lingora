import 'package:lingora/features/words/domain/repositories/library_repository.dart';
import 'package:lingora/features/words/domain/usecases/params/favorites_params.dart';

class RemoveFromFavoritesUsecase {
  final LibraryRepository libraryRepository;

  RemoveFromFavoritesUsecase(this.libraryRepository);

  Future<void> call(FavoritesParams params) {
    return libraryRepository.removeFromFavorites(params);
  }
}
