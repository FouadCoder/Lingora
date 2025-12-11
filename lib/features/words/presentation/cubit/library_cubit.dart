import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/usecases/play_audio_usecase.dart';
import 'package:lingora/features/words/domain/enums/collection_enum.dart';
import 'package:lingora/features/words/domain/usecases/collections_params.dart';
import 'package:lingora/features/words/domain/usecases/get_library_usecase.dart';
import 'package:lingora/features/words/domain/usecases/library_params.dart';
import 'package:lingora/features/words/domain/usecases/update_word_collection_usecase.dart';
import 'package:lingora/features/words/presentation/cubit/library_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final SupabaseClient supabaseClient;
  final GetLibraryUsecase getLibraryUsecase;
  final UpdateWordCollectionUsecase updateWordCollectionUsecase;
  final PlayAudioUsecase playAudioUsecase;
  LibraryCubit(this.supabaseClient, this.getLibraryUsecase,
      this.updateWordCollectionUsecase, this.playAudioUsecase)
      : super(const LibraryState());

  int _offset = 0;

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

  // Update word collection
  void updateWordCollection(String wordId, CollectionType collection) async {
    try {
      // If loading already
      if (state.actionStatus == LibraryActionStatus.loading) return;
      emit(state.copyWith(actionStatus: LibraryActionStatus.loading));
      // Update
      await updateWordCollectionUsecase.call(CollectionsParams(
          wordId: wordId, collectionName: collection.sourceName));
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
}
