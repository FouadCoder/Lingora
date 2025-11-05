import 'package:lingora/features/translate/domain/entities/translate_entity.dart';
import 'package:lingora/features/library/domain/repositories/library_repository.dart';

class GetLibraryUsecase {
  final LibraryRepository libraryRepository;
  GetLibraryUsecase(this.libraryRepository);

  Future<List<TranslateEntity>> call() async {
    return await libraryRepository.getLibrary();
  }
}
