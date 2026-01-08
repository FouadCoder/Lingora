import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/exceptions/network_exception.dart';
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

      // Update note
      final params = NotesParams(wordId: wordEntity.id!, content: content);
      final newNote = await updateNoteUsecase.call(params);
      final updatedWord = wordEntity.copyWith(note: newNote);
      emit(state.copyWith(status: NotesStatus.success, word: updatedWord));
    } on NetworkException {
      emit(state.copyWith(status: NotesStatus.networkError));
    } catch (e) {
      emit(state.copyWith(status: NotesStatus.failure));
    }
  }
}
