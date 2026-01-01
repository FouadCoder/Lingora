import 'package:lingora/features/words/domain/entities/favorite_entity.dart';
import 'package:lingora/features/words/domain/repositories/library_repository.dart';
import 'package:lingora/features/words/domain/usecases/params/favorites_params.dart';

class GetFavoritesUsecase {
  final LibraryRepository libraryRepository;

  GetFavoritesUsecase(this.libraryRepository);

  Future<List<FavoriteEntity>> call(FavoritesParams params) {
    return libraryRepository.getFavorites(params);
  }
}
