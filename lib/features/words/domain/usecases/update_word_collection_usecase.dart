import 'package:lingora/features/words/domain/entities/collection_entity.dart';
import 'package:lingora/features/words/domain/repositories/library_repository.dart';
import 'package:lingora/features/words/domain/usecases/params/collections_params.dart';

class UpdateWordCollectionUsecase {
  final LibraryRepository libraryRepository;

  UpdateWordCollectionUsecase(this.libraryRepository);

  Future<CollectionEntity> call(CollectionsParams params) async {
    return await libraryRepository.updateWordCollection(params);
  }
}
