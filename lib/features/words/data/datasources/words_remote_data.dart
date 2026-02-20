import 'package:lingora/features/words/data/models/collection_model.dart';
import 'package:lingora/features/words/data/models/favorite_model.dart';
import 'package:lingora/features/words/data/models/note_model.dart';
import 'package:lingora/features/words/data/models/word_model.dart';
import 'package:lingora/features/words/domain/usecases/params/collections_params.dart';
import 'package:lingora/features/words/domain/usecases/params/library_params.dart';
import 'package:lingora/features/words/domain/usecases/params/favorites_params.dart';
import 'package:lingora/features/words/domain/usecases/params/notes_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class WordsRemoteData {
  Future<List<WordModel>> getLibrary(LibraryParams params);
  Future<List<WordModel>> getWordsByCollection(LibraryParams params);
  Future<CollectionModel> updateWordCollection(CollectionsParams params);
  Future<NoteModel> updateNote(NotesParams params);
  Future<List<FavoriteModel>> getFavorites(FavoritesParams params);
  Future addToFavorites(FavoritesParams params);
  Future removeFromFavorites(FavoritesParams params);
}

class WordsRemoteDataImpl implements WordsRemoteData {
  final SupabaseClient supabaseClient;

  WordsRemoteDataImpl(this.supabaseClient);

  String get _userId => supabaseClient.auth.currentUser!.id;

  // Get library words
  @override
  Future<List<WordModel>> getLibrary(LibraryParams params) async {
    final List<Map<String, dynamic>> data = await supabaseClient
        .from('translated_words')
        .select('* , notes(*) , collections(*) , favorites(*) , reminders(*)')
        .eq('user_id', _userId)
        .isFilter('deleted_at', null)
        .order('created_at', ascending: false)
        .range(params.offset, params.offset + 15 - 1);
    List<WordModel> words = data.map((e) => WordModel.fromJson(e)).toList();

    return words;
  }

  // Get word for specific collections
  @override
  Future<List<WordModel>> getWordsByCollection(LibraryParams params) async {
    final List<Map<String, dynamic>> data = await supabaseClient
        .from('translated_words')
        .select('* , notes(*) , collections!inner(*) , favorites(*)')
        .eq('user_id', _userId)
        .eq('collections.collection_type', params.collectionType!)
        .isFilter('deleted_at', null)
        .order('created_at', ascending: false)
        .range(params.offset, params.offset + 15 - 1);

    List<WordModel> words = data.map((e) => WordModel.fromJson(e)).toList();

    return words;
  }

  // Update word collection
  @override
  Future<CollectionModel> updateWordCollection(CollectionsParams params) async {
    // Get the collection_id for this user and type
    final collection = await supabaseClient
        .from('collections')
        .select('id')
        .eq('user_id', _userId)
        .eq('collection_type', params.collectionType)
        .single();

    // Update the word with the collection_id
    final data = await supabaseClient
        .from('translated_words')
        .update({
          'collection_id': collection['id'],
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', params.wordId)
        .select('collections(*)')
        .single();
    return CollectionModel.fromJson(data['collections']);
  }

  // Update note
  @override
  Future<NoteModel> updateNote(NotesParams params) async {
    final note = await supabaseClient
        .from('notes')
        .upsert(
          {
            'user_id': _userId,
            'word_id': params.wordId,
            'content': params.content,
          },
          onConflict: "word_id",
        )
        .select()
        .single();
    return NoteModel.fromJson(note);
  }

  // Get favorites
  @override
  Future<List<FavoriteModel>> getFavorites(FavoritesParams params) async {
    final data = await supabaseClient
        .from('favorites')
        .select('''
            *,
            translated_words:translated_word_id(*)
          ''')
        .eq('user_id', _userId)
        .order('created_at', ascending: false)
        .range(params.offset, params.offset + 15 - 1);

    List<FavoriteModel> favorites =
        data.map((e) => FavoriteModel.fromJson(e)).toList();

    return favorites;
  }

  // Add to favorites
  @override
  Future addToFavorites(FavoritesParams params) async {
    await supabaseClient.from('favorites').insert({
      'user_id': _userId,
      'word_id': params.wordId,
    });
  }

  // Remove from favorites
  @override
  Future removeFromFavorites(FavoritesParams params) async {
    await supabaseClient
        .from('favorites')
        .delete()
        .eq('user_id', _userId)
        .eq('word_id', params.wordId!);
  }
}
