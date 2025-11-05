import 'package:lingora/features/library/domain/entities/word_entity.dart';
import 'package:lingora/features/library/domain/repositories/library_repository.dart';

class GetLibraryUsecase {
  final LibraryRepository libraryRepository;
  GetLibraryUsecase(this.libraryRepository);

  Future<List<WordEntity>> call() async {
    return await libraryRepository.getLibrary();
  }
}
