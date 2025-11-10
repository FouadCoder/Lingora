import 'package:lingora/features/library/domain/entities/word_entity.dart';
import 'package:lingora/features/library/domain/repositories/library_repository.dart';
import 'package:lingora/features/library/domain/usecases/library_params.dart';

class GetLibraryUsecase {
  final LibraryRepository libraryRepository;
  GetLibraryUsecase(this.libraryRepository);

  Future<List<WordEntity>> call(LibraryParams params) async {
    return await libraryRepository.getLibrary(params);
  }
}
