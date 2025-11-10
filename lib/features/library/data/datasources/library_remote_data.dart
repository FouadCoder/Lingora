import 'package:lingora/features/library/data/models/word_model.dart';
import 'package:lingora/features/library/domain/usecases/library_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LibraryRemoteData {
  final SupabaseClient supabaseClient;

  LibraryRemoteData(this.supabaseClient);

  Future<List<WordModel>> getLibrary(LibraryParams params) async {
    final List<Map<String, dynamic>> data = await supabaseClient
        .from('translated_words')
        .select('* , notes(*) , categories(*)')
        .eq('user_id', supabaseClient.auth.currentUser!.id)
        .isFilter('deleted_at', null)
        .order('created_at', ascending: false)
        .range(params.offset, params.offset + 15 - 1);
    List<WordModel> words = data.map((e) => WordModel.fromJson(e)).toList();
    return words;
  }
}
