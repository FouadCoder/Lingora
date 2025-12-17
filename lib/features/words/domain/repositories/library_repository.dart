import 'package:lingora/features/words/domain/entities/favorite_entity.dart';
import 'package:lingora/features/words/domain/entities/note_entity.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/domain/usecases/params/collections_params.dart';
import 'package:lingora/features/words/domain/usecases/params/library_params.dart';
import 'package:lingora/features/words/domain/usecases/params/favorites_params.dart';
import 'package:lingora/features/words/domain/usecases/params/notes_params.dart';

abstract class LibraryRepository {
  Future<List<WordEntity>> getLibrary(LibraryParams params);
  Future<List<WordEntity>> getWordsByCollection(LibraryParams params);
  Future<void> updateWordCollection(CollectionsParams params);
  Future<NoteEntity> updateNote(NotesParams params);
  Future<List<FavoriteEntity>> getFavorites(FavoritesParams params);
  Future<void> addToFavorites(FavoritesParams params);
  Future<void> removeFromFavorites(FavoritesParams params);
}
