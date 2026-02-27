import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/exceptions/network_exception.dart';
import 'package:lingora/core/usecases/play_audio_usecase.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/domain/entities/note_entity.dart';
import 'package:lingora/features/words/domain/entities/collection_entity.dart';
import 'package:lingora/features/notification/domain/entities/reminder_entity.dart';
import 'package:lingora/features/words/domain/enums/collection_enum.dart';
import 'package:lingora/features/words/domain/usecases/library_usecase/get_library_usecase.dart';
import 'package:lingora/features/words/domain/usecases/library_usecase/get_words_by_collection_usecase.dart';
import 'package:lingora/features/words/domain/usecases/params/collections_params.dart';
import 'package:lingora/features/words/domain/usecases/params/library_params.dart';
import 'package:lingora/features/words/domain/usecases/update_word_collection_usecase.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final SupabaseClient supabaseClient;
  final GetLibraryUsecase getLibraryUsecase;
  final UpdateWordCollectionUsecase updateWordCollectionUsecase;
  final GetWordsByCollectionUsecase getWordsByCollectionUsecase;
  final PlayAudioUsecase playAudioUsecase;
  LibraryCubit(
      this.supabaseClient,
      this.getLibraryUsecase,
      this.updateWordCollectionUsecase,
      this.getWordsByCollectionUsecase,
      this.playAudioUsecase)
      : super(const LibraryState());

  int _offset = 0;
  int _collectionsOffset = 0;
  DateTime? lastRefresh;

  Future<void> loadMoreLibrary() async {
    try {
      // Check if already loading
      if (state.isLoadingMore || !state.hasMore) return;

      emit(state.copyWith(
          isLoadingMore: true, actionStatus: LibraryActionStatus.initial));

      // Get library
      final libraryWords =
          await getLibraryUsecase.call(LibraryParams(offset: _offset));

      // Update offset
      _offset += libraryWords.length;
      bool hasMore = libraryWords.length == 15;

      emit(state.copyWith(
          isLoadingMore: false,
          libraryWords: [...state.libraryWords, ...libraryWords],
          hasMore: hasMore,
          actionStatus: LibraryActionStatus.initial));
    } on NetworkException {
      emit(state.copyWith(
          isLoadingMore: false, status: LibraryStatus.networkError));
    } catch (_) {}
  }

  Future<void> getLibrary({bool forceRefresh = false}) async {
    try {
      // If loaded already and not forcing refresh
      if (!forceRefresh &&
          (state.libraryWords.isNotEmpty ||
              state.status == LibraryStatus.empty)) {
        emit(state.copyWith(
            status: state.libraryWords.isNotEmpty
                ? LibraryStatus.success
                : LibraryStatus.empty,
            libraryWords: state.libraryWords));
        return;
      }

      if (!forceRefresh) {
        emit(state.copyWith(status: LibraryStatus.loading));
      }

      // If user is not logged in
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(
          status: LibraryStatus.failure,
        ));
        return;
      }

      // Get library
      final libraryWords =
          await getLibraryUsecase.call(LibraryParams(offset: 0));

      // Check if empty
      if (libraryWords.isEmpty) {
        emit(state.copyWith(
          status: LibraryStatus.empty,
        ));
        return;
      }

      // Update offset
      _offset = libraryWords.length;

      emit(state.copyWith(
          status: LibraryStatus.success, libraryWords: libraryWords));
    } on NetworkException {
      emit(state.copyWith(status: LibraryStatus.networkError));
    } catch (e) {
      emit(state.copyWith(status: LibraryStatus.failure));
    }
  }

  Future<void> refreshLibrary() async {
    DateTime now = DateTime.now();

    if (lastRefresh == null) {
      await getLibrary(forceRefresh: true);
      lastRefresh = now;
      return;
    }

    int minutesLeft = now.difference(lastRefresh!).inMinutes;
    int minutesRemaining = 5 - minutesLeft;

    if (minutesLeft >= 5) {
      await getLibrary(forceRefresh: true);
      lastRefresh = now;
    } else {
      emit(
        state.copyWith(
            actionStatus: LibraryActionStatus.limitExceeded,
            minutesUntilRefresh: minutesRemaining),
      );
    }
  }

  void getWordsByCollection(String collectionType) async {
    try {
      // Reset offset when getting a new collection
      _collectionsOffset = 0;

      emit(state.copyWith(
        collectionStatus: LibraryStatus.loading,
        collectionsWords: const [], // Clear previous collection words
        hasMoreCollections: true, // Reset hasMore flag
      ));

      final words = await getWordsByCollectionUsecase.call(LibraryParams(
        offset: _collectionsOffset,
        collectionType: collectionType,
      ));

      // Update offset and check if there are more items
      _collectionsOffset = words.length;
      bool hasMore = words.length == 15; // Assuming 15 is page size

      // Empty
      if (words.isEmpty) {
        emit(state.copyWith(
            collectionStatus: LibraryStatus.empty, hasMore: false));
        return;
      }

      // Success
      emit(state.copyWith(
        collectionStatus: LibraryStatus.success,
        collectionsWords: words,
        hasMoreCollections: hasMore,
      ));
    } on NetworkException {
      emit(state.copyWith(
        collectionStatus: LibraryStatus.networkError,
        hasMoreCollections: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        collectionStatus: LibraryStatus.failure,
        hasMoreCollections: false,
      ));
    }
  }

  void loadMoreCollections(String collectionType) async {
    try {
      // Check if already loading or no more collections to load
      if (state.isLoadingMore || !state.hasMoreCollections) return;

      emit(state.copyWith(isLoadingMore: true));

      // Get more collection words
      final moreWords = await getWordsByCollectionUsecase.call(LibraryParams(
        offset: _collectionsOffset,
        collectionType: collectionType,
      ));

      // Update offset
      _collectionsOffset += moreWords.length;
      bool hasMore = moreWords.length == 15;

      // Update state with new words
      emit(state.copyWith(
        isLoadingMore: false,
        collectionsWords: [...state.collectionsWords, ...moreWords],
        hasMoreCollections: hasMore,
      ));
    } on NetworkException {
      emit(state.copyWith(
          isLoadingMore: false, status: LibraryStatus.networkError));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  void updateWordCollection(String wordId, CollectionType collection) async {
    try {
      // If loading already
      if (state.collectionActionStatus == LibraryActionStatus.loading) return;
      emit(state.copyWith(collectionActionStatus: LibraryActionStatus.loading));
      // Update
      final newCollection = await updateWordCollectionUsecase.call(
          CollectionsParams(wordId: wordId, collectionType: collection.name));
      // Replace word from memory
      refreshWord(wordId: wordId, collection: newCollection);
      // Remove word
      final updatedCollectionsWords =
          state.collectionsWords.where((w) => w.id != wordId).toList();
      emit(state.copyWith(
          collectionActionStatus: LibraryActionStatus.success,
          collectionsWords: updatedCollectionsWords));
    } on NetworkException {
      emit(state.copyWith(
          collectionActionStatus: LibraryActionStatus.networkError));
    } catch (e) {
      emit(state.copyWith(collectionActionStatus: LibraryActionStatus.failure));
    }
  }

  void playAudio(String word, String lang) async {
    try {
      await playAudioUsecase.call(word, lang: lang);
    } catch (_) {}
  }

  WordEntity getWordById(String id) {
    return state.libraryWords.firstWhere((w) => w.id == id);
  }

  // Replace or update word on memory
  void refreshWord({
    required String wordId,
    String? original,
    String? translated,
    String? pos,
    String? pronunciation,
    String? meaning,
    List<String>? examples,
    List<String>? synonyms,
    bool? isFavorite,
    bool? activeReminder,
    NoteEntity? note,
    CollectionEntity? collection,
    ReminderEntity? reminder,
  }) async {
    try {
      final currentWords = state.libraryWords;
      final updatedWords = currentWords.map((w) {
        if (w.id == wordId) {
          return w.copyWith(
            original: original,
            translated: translated,
            pos: pos,
            pronunciation: pronunciation,
            meaning: meaning,
            examples: examples,
            synonyms: synonyms,
            isFavorite: isFavorite,
            activeReminder: activeReminder,
            note: note,
            collection: collection,
            reminder: reminder,
          );
        }
        return w;
      }).toList();
      emit(state.copyWith(
          libraryWords: updatedWords,
          collectionActionStatus: LibraryActionStatus.initial));
    } catch (_) {}
  }

  // Reset cubit state (for logout)
  void reset() {
    _offset = 0;
    _collectionsOffset = 0;
    emit(const LibraryState());
  }
}
