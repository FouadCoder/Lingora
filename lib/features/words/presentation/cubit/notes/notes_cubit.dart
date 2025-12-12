import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/words/domain/usecases/notes_usecase/update_note_usecase.dart';
import 'package:lingora/features/words/domain/usecases/params/notes_params.dart';
import 'package:lingora/features/words/presentation/cubit/notes/notes_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesCubit extends Cubit<NotesState> {
  final SupabaseClient supabaseClient;
  final UpdateNoteUsecase updateNoteUsecase;
  NotesCubit(this.supabaseClient, this.updateNoteUsecase) : super(NotesState());

  void updateNote(String content, String? wordId) async {
    try {
      emit(state.copyWith(status: NotesStatus.loading));

      // Check empty content
      if (content.isEmpty) {
        return;
      }

      // Check userId
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(status: NotesStatus.failure));
        return;
      }
      // Check WordId
      if (wordId == null || wordId.isEmpty) {
        emit(state.copyWith(status: NotesStatus.failure));
        return;
      }

      // Update note
      final params =
          NotesParams(userId: userId, wordId: wordId, content: content);
      await updateNoteUsecase.call(params);

      emit(state.copyWith(status: NotesStatus.success));
    } catch (e) {
      emit(state.copyWith(status: NotesStatus.failure));
    }
  }
}
