import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/domain/repositories/library_repository.dart';
import 'package:lingora/features/words/domain/usecases/params/library_params.dart';

class GetLibraryUsecase {
  final LibraryRepository libraryRepository;
  GetLibraryUsecase(this.libraryRepository);

  Future<List<WordEntity>> call(LibraryParams params) async {
    return await libraryRepository.getLibrary(params);
  }
}
