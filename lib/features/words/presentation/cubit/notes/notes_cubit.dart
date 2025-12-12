import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/domain/usecases/notes_usecase/update_note_usecase.dart';
import 'package:lingora/features/words/domain/usecases/params/notes_params.dart';
import 'package:lingora/features/words/presentation/cubit/notes/notes_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesCubit extends Cubit<NotesState> {
  final SupabaseClient supabaseClient;
  final UpdateNoteUsecase updateNoteUsecase;
  NotesCubit(this.supabaseClient, this.updateNoteUsecase) : super(NotesState());

  void updateNote(String content, WordEntity wordEntity) async {
    try {
      emit(state.copyWith(status: NotesStatus.loading));

      // Check empty content
      if (content.isEmpty) {
        return;
      }

      // Check userId && wordId
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null || wordEntity.id == null || wordEntity.id!.isEmpty) {
        emit(state.copyWith(status: NotesStatus.failure));
        return;
      }

      // Update note
      final params =
          NotesParams(userId: userId, wordId: wordEntity.id!, content: content);
      final newNote = await updateNoteUsecase.call(params);
      wordEntity.copyWith(note: newNote);

      emit(state.copyWith(status: NotesStatus.success, word: wordEntity));
    } catch (e) {
      emit(state.copyWith(status: NotesStatus.failure));
    }
  }
}
