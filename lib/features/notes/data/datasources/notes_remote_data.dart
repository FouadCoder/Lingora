import 'package:lingora/features/notes/domain/usecases/notes_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesRemoteData {
  final SupabaseClient supabaseClient;

  NotesRemoteData(this.supabaseClient);
  Future updateNote(NotesParams params) async {
    await supabaseClient.from('notes').upsert(
      {
        'user_id': params.userId,
        'word_id': params.wordId,
        'content': params.content,
      },
      onConflict: "word_id",
    );
  }
}
