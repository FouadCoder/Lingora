import 'package:lingora/features/words/data/models/collection_model.dart';
import 'package:lingora/features/words/data/models/favorite_model.dart';
import 'package:lingora/features/words/data/models/note_model.dart';
import 'package:lingora/features/words/data/models/word_model.dart';
import 'package:lingora/features/words/domain/entities/collection_entity.dart';
import 'package:lingora/features/words/domain/entities/favorite_entity.dart';
import 'package:lingora/features/words/domain/entities/note_entity.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/data/datasources/words_remote_data.dart';
import 'package:lingora/features/words/domain/repositories/library_repository.dart';
import 'package:lingora/features/words/domain/usecases/params/collections_params.dart';
import 'package:lingora/features/words/domain/usecases/params/library_params.dart';
import 'package:lingora/features/words/domain/usecases/params/favorites_params.dart';
import 'package:lingora/features/words/domain/usecases/params/notes_params.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final WordsRemoteData wordsRemoteData;
  LibraryRepositoryImpl(this.wordsRemoteData);

  @override
  Future<List<WordEntity>> getLibrary(LibraryParams params) async {
    List<WordModel> libraryWords = await wordsRemoteData.getLibrary(params);
    List<WordEntity> libraryWordsEntity =
        libraryWords.map((e) => e.toEntity()).toList();
    return libraryWordsEntity;
  }

  @override
  Future<List<WordEntity>> getWordsByCollection(LibraryParams params) async {
    List<WordModel> libraryWords =
        await wordsRemoteData.getWordsByCollection(params);
    List<WordEntity> libraryWordsEntity =
        libraryWords.map((e) => e.toEntity()).toList();
    return libraryWordsEntity;
  }

  @override
  Future<CollectionEntity> updateWordCollection(
      CollectionsParams params) async {
    CollectionModel collectionModel =
        await wordsRemoteData.updateWordCollection(CollectionsParams(
      collectionType: params.collectionType,
      wordId: params.wordId,
    ));

    return collectionModel.toEntity();
  }

  @override
  Future<NoteEntity> updateNote(NotesParams params) async {
    NoteModel noteModel = await wordsRemoteData.updateNote(params);
    return noteModel.toEntity();
  }

  @override
  Future<void> addToFavorites(FavoritesParams params) async {
    return await wordsRemoteData.addToFavorites(params);
  }

  @override
  Future<List<FavoriteEntity>> getFavorites(FavoritesParams params) async {
    List<FavoriteModel> data = await wordsRemoteData.getFavorites(params);
    List<FavoriteEntity> favorites = data.map((e) => e.toEntity()).toList();
    return favorites;
  }

  @override
  Future<void> removeFromFavorites(FavoritesParams params) async {
    return await wordsRemoteData.removeFromFavorites(params);
  }
}
