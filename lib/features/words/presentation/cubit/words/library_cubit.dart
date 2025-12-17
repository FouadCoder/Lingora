import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/usecases/play_audio_usecase.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/domain/enums/collection_enum.dart';
import 'package:lingora/features/words/domain/usecases/library_usecase/get_library_usecase.dart';
import 'package:lingora/features/words/domain/usecases/library_usecase/get_words_by_collection_usecase.dart';
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
  final int _collectionsOffset = 0;

  void loadMoreLibrary() async {
    try {
      // Check if already loading
      if (state.isLoadingMore || !state.hasMore) return;

      emit(state.copyWith(isLoadingMore: true));

      // Get library
      final libraryWords =
          await getLibraryUsecase.call(LibraryParams(offset: _offset));

      // Update offset
      _offset += libraryWords.length;
      bool hasMore = libraryWords.length == 15;

      emit(state.copyWith(
          isLoadingMore: false,
          libraryWords: [...state.libraryWords, ...libraryWords],
          hasMore: hasMore));
    } catch (_) {}
  }

  void getLibrary() async {
    try {
      // If loaded already
      if (state.libraryWords.isNotEmpty) {
        emit(state.copyWith(
            status: LibraryStatus.success, libraryWords: state.libraryWords));
        return;
      }
      emit(state.copyWith(status: LibraryStatus.loading));

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
    } catch (e) {
      emit(state.copyWith(status: LibraryStatus.failure));
    }
  }

  void getWordsByCollection(String collectionType) async {
    try {
      emit(state.copyWith(status: LibraryStatus.loading));
      final words = await getWordsByCollectionUsecase.call(LibraryParams(
          offset: _collectionsOffset, collectionType: collectionType));

      print("Success getting words collections ========================== ");
      emit(state.copyWith(
          status: LibraryStatus.success, collectionsWords: words));
    } catch (e) {
      print("Error getting words collections ==========================   $e");
      emit(state.copyWith(status: LibraryStatus.failure));
    }
  }

  // Update word collection
  void updateWordCollection(String wordId, CollectionType collection) async {
    try {
      // If loading already
      if (state.actionStatus == LibraryActionStatus.loading) return;
      emit(state.copyWith(actionStatus: LibraryActionStatus.loading));
      // Update
      // await updateWordCollectionUsecase.call(CollectionsParams(
      //     wordId: wordId, collectionName: collection.sourceName));
      //TODO FIX THIS
      emit(state.copyWith(actionStatus: LibraryActionStatus.success));
    } catch (e) {
      emit(state.copyWith(actionStatus: LibraryActionStatus.failure));
    }
  }

  // Play audio
  void playAudio(String word, String lang) async {
    try {
      await playAudioUsecase.call(word, lang: lang);
    } catch (_) {}
  }

  // Replace or update word on memory
  void refreshWord(WordEntity word) async {
    try {
      final currentWords = state.libraryWords;
      final updatedWords = currentWords.map((w) {
        return w.id == word.id ? word : w;
      }).toList();
      emit(state.copyWith(libraryWords: updatedWords));
    } catch (_) {}
  }
}
