import 'package:lingora/core/exceptions/network_exception.dart';
import 'package:lingora/core/service/network_service.dart';
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
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    List<WordModel> libraryWords = await wordsRemoteData.getLibrary(params);
    List<WordEntity> libraryWordsEntity =
        libraryWords.map((e) => e.toEntity()).toList();
    return libraryWordsEntity;
  }

  @override
  Future<List<WordEntity>> getWordsByCollection(LibraryParams params) async {
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    List<WordModel> libraryWords =
        await wordsRemoteData.getWordsByCollection(params);
    List<WordEntity> libraryWordsEntity =
        libraryWords.map((e) => e.toEntity()).toList();
    return libraryWordsEntity;
  }

  @override
  Future<CollectionEntity> updateWordCollection(
      CollectionsParams params) async {
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    CollectionModel collectionModel =
        await wordsRemoteData.updateWordCollection(CollectionsParams(
      collectionType: params.collectionType,
      wordId: params.wordId,
    ));

    return collectionModel.toEntity();
  }

  @override
  Future<NoteEntity> updateNote(NotesParams params) async {
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    NoteModel noteModel = await wordsRemoteData.updateNote(params);
    return noteModel.toEntity();
  }

  @override
  Future<FavoriteEntity> addToFavorites(FavoritesParams params) async {
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    final favoriteModel = await wordsRemoteData.addToFavorites(params);
    return favoriteModel.toEntity();
  }

  @override
  Future<List<FavoriteEntity>> getFavorites(FavoritesParams params) async {
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    List<FavoriteModel> data = await wordsRemoteData.getFavorites(params);
    List<FavoriteEntity> favorites = data.map((e) => e.toEntity()).toList();
    return favorites;
  }

  @override
  Future<void> removeFromFavorites(FavoritesParams params) async {
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    return await wordsRemoteData.removeFromFavorites(params);
  }
}
