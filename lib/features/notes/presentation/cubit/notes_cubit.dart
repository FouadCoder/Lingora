import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/notes/domain/usecases/notes_params.dart';
import 'package:lingora/features/notes/domain/usecases/update_note_usecase.dart';
import 'package:lingora/features/notes/presentation/cubit/notes_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesCubit extends Cubit<NotesState> {
  final SupabaseClient supabaseClient;
  final UpdateNoteUsecase updateNoteUsecase;
  NotesCubit(this.supabaseClient, this.updateNoteUsecase) : super(NotesState());

  void updateNote(String content, String? wordId) async {
    try {
      print("=========Start updating note =======================");
      emit(state.copyWith(status: NotesStatus.loading));
      print(
          "================Updating note with content: $content and wordId: $wordId");

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
      print("============================= Error saving notes ============$e");
      emit(state.copyWith(status: NotesStatus.failure));
    }
  }
}
