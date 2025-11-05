import 'package:lingora/features/notes/domain/usecases/notes_params.dart';

abstract class NotesRepository {
  Future updateNote(NotesParams params);
}
