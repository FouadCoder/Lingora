import 'package:lingora/features/translate/data/models/translate_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LibraryRemoteData {
  final SupabaseClient supabaseClient;

  LibraryRemoteData(this.supabaseClient);

  Future<List<TranslateModel>> getLibrary() async {
    final List<dynamic> data = await supabaseClient
        .from('translated_words')
        .select()
        .eq('user_id', supabaseClient.auth.currentUser!.id)
        .isFilter('deleted_at', null);
    List<TranslateModel> words =
        data.map((e) => TranslateModel.fromJson(e)).toList();
    return words;
  }
}
