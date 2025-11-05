import 'package:lingora/features/library/data/models/word_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LibraryRemoteData {
  final SupabaseClient supabaseClient;

  LibraryRemoteData(this.supabaseClient);

  Future<List<WordModel>> getLibrary() async {
    final List<Map<String, dynamic>> data = await supabaseClient
        .from('translated_words')
        .select('* , notes(*) , categories(*)')
        .eq('user_id', supabaseClient.auth.currentUser!.id)
        .isFilter('deleted_at', null);
    for (var element in data) {
      print(element);
    }
    List<WordModel> words = data.map((e) => WordModel.fromJson(e)).toList();
    return words;
  }
}
