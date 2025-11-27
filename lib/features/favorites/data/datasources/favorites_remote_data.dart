import 'package:lingora/features/favorites/domain/usecases/favorites_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesRemoteData {
  final SupabaseClient supabaseClient;

  FavoritesRemoteData(this.supabaseClient);

  // Get favorites
  Future getFavorites(FavoritesParams params) async {
    await supabaseClient
        .from('favorites')
        .select('''
            *,
            translated_words:translated_word_id(*)
          ''')
        .eq('user_id', params.userId)
        .isFilter('deleted_at', null)
        .order('created_at', ascending: false);
  }

  // Add to favorites
  Future addToFavorites(FavoritesParams params) async {
    await supabaseClient.from('favorites').upsert({
      'user_id': params.userId,
      'translated_word_id': params.wordId,
      'deleted_at': null,
    }).select('''
            *,
            translated_words:translated_word_id(*)
          ''').single();
  }

  // Remove from favorites
  Future removeFromFavorites(FavoritesParams params) async {
    await Supabase.instance.client
        .from('favorites')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('user_id', params.userId)
        .eq('translated_word_id', params.wordId!)
        .isFilter('deleted_at', null);
  }
}
