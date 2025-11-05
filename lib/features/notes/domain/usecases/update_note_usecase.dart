import 'package:lingora/features/notes/domain/repositories/notes_repository.dart';
import 'package:lingora/features/notes/domain/usecases/notes_params.dart';

class UpdateNoteUsecase {
  final NotesRepository repository;

  UpdateNoteUsecase(this.repository);

  Future call(NotesParams params) async {
    return await repository.updateNote(params);
  }
}
