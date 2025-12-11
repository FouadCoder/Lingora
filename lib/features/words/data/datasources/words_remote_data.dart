import 'package:lingora/features/notes/domain/usecases/notes_params.dart';
import 'package:lingora/features/words/data/models/collection_model.dart';
import 'package:lingora/features/words/data/models/word_model.dart';
import 'package:lingora/features/words/domain/usecases/params/collections_params.dart';
import 'package:lingora/features/words/domain/usecases/library_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class WordsRemoteData {
  Future<List<WordModel>> getLibrary(LibraryParams params);
  Future<List<WordModel>> getLibraryCollectionWords(LibraryParams params);
  Future<List<CollectionModel>> getCollections();
  Future<void> updateWordCollection(CollectionsParams params);
  Future<void> updateNote(NotesParams params);
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
        .select('* , notes(*) , collections(*) , favorites(*)')
        .eq('user_id', _userId)
        .order('created_at', ascending: false)
        .range(params.offset, params.offset + 15 - 1);

    List<WordModel> words = data.map((e) => WordModel.fromJson(e)).toList();

    return words;
  }

  // Get library collection words
  @override
  Future<List<WordModel>> getLibraryCollectionWords(
      LibraryParams params) async {
    final List<Map<String, dynamic>> data = await supabaseClient
        .from('translated_words')
        .select('* , notes(*) , collections(*)')
        .eq('user_id', _userId)
        .eq("collection_id", params.collectionId!)
        .isFilter('deleted_at', null)
        .order('created_at', ascending: false)
        .range(params.offset, params.offset + 15 - 1);
    List<WordModel> words = data.map((e) => WordModel.fromJson(e)).toList();
    return words;
  }

  // Get collections IDS
  @override
  Future<List<CollectionModel>> getCollections() async {
    final List<Map<String, dynamic>> data = await supabaseClient
        .from('collections')
        .select('id , name')
        .eq("user_id", _userId)
        .isFilter('deleted_at', null);

    List<CollectionModel> collections =
        data.map((e) => CollectionModel.fromJson(e)).toList();
    return collections;
  }

  // Update word collection
  @override
  Future<void> updateWordCollection(CollectionsParams params) async {
    await supabaseClient.from('translated_words').update({
      'collection_id': params.collectionId,
    }).eq('id', params.wordId);
  }

  // Update note
  @override
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
