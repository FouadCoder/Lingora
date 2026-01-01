import 'package:lingora/features/words/domain/entities/note_entity.dart';
import 'package:lingora/features/words/domain/repositories/library_repository.dart';
import 'package:lingora/features/words/domain/usecases/params/notes_params.dart';

class UpdateNoteUsecase {
  final LibraryRepository libraryRepository;
  UpdateNoteUsecase(this.libraryRepository);

  Future<NoteEntity> call(NotesParams params) async {
    return await libraryRepository.updateNote(params);
  }
}
