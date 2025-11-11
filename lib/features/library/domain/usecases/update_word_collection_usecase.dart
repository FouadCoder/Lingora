import 'package:lingora/features/library/domain/repositories/library_repository.dart';
import 'package:lingora/features/library/domain/usecases/collections_params.dart';

class UpdateWordCollectionUsecase {
  final LibraryRepository libraryRepository;

  UpdateWordCollectionUsecase(this.libraryRepository);

  Future<void> call(CollectionsParams params) async {
    await libraryRepository.updateWordCollection(params);
  }
}
