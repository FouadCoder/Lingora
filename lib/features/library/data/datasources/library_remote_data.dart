import 'package:lingora/features/library/data/models/collection_model.dart';
import 'package:lingora/features/library/data/models/word_model.dart';
import 'package:lingora/features/library/domain/usecases/collections_params.dart';
import 'package:lingora/features/library/domain/usecases/library_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LibraryRemoteData {
  final SupabaseClient supabaseClient;

  LibraryRemoteData(this.supabaseClient);

  String get _userId => supabaseClient.auth.currentUser!.id;

  // Get library words
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
  Future<void> updateWordCollection(CollectionsParams params) async {
    await supabaseClient.from('translated_words').update({
      'collection_id': params.collectionId,
    }).eq('id', params.wordId);
  }
}
