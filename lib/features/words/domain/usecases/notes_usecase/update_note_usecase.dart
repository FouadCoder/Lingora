import 'package:lingora/features/words/domain/repositories/library_repository.dart';
import 'package:lingora/features/words/domain/usecases/params/notes_params.dart';

class UpdateNoteUsecase {
  final LibraryRepository libraryRepository;
  UpdateNoteUsecase(this.libraryRepository);

  Future<void> call(NotesParams params) async {
    await libraryRepository.updateNote(params);
  }
}
