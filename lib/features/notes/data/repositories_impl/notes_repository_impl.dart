import 'package:lingora/features/notes/data/datasources/notes_remote_data.dart';
import 'package:lingora/features/notes/domain/repositories/notes_repository.dart';
import 'package:lingora/features/notes/domain/usecases/notes_params.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteData remoteData;

  NotesRepositoryImpl(this.remoteData);

  @override
  Future updateNote(NotesParams params) {
    return remoteData.updateNote(params);
  }
}
