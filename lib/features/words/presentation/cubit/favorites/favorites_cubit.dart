import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/words/domain/entities/favorite_entity.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/domain/usecases/favorites_usecase/add_to_favorites_usecase.dart';
import 'package:lingora/features/words/domain/usecases/params/favorites_params.dart';
import 'package:lingora/features/words/domain/usecases/favorites_usecase/get_favorites_usecase.dart';
import 'package:lingora/features/words/domain/usecases/favorites_usecase/remove_from_favorites_usecase.dart';
import 'package:lingora/features/words/presentation/cubit/favorites/favorites_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final SupabaseClient supabaseClient;
  final GetFavoritesUsecase getFavoritesUsecase;
  final AddToFavoritesUsecase addToFavoritesUsecase;
  final RemoveFromFavoritesUsecase removeFromFavoritesUsecase;
  FavoritesCubit(
    this.supabaseClient,
    this.getFavoritesUsecase,
    this.addToFavoritesUsecase,
    this.removeFromFavoritesUsecase,
  ) : super(FavoritesState());

  String get _userId => supabaseClient.auth.currentUser!.id;

  // Get favorites
  void getFavorites() async {
    try {
      // Check if there data exist
      if (state.favorites.isNotEmpty) {
        emit(state.copyWith(
          status: FavoriteStatus.success,
          favorites: state.favorites,
        ));
        return;
      }

      // Get
      emit(state.copyWith(status: FavoriteStatus.loading));
      final List<FavoriteEntity> favorites = await getFavoritesUsecase
          .call(FavoritesParams(userId: _userId, offset: 0));

      // If empty
      if (favorites.isEmpty) {
        emit(state.copyWith(status: FavoriteStatus.empty));
        return;
      }

      for (var item in favorites) {
        print(
            "Favorites ================================== ${item.word.isFavorite}");
      }

      emit(state.copyWith(
          status: FavoriteStatus.success,
          favorites: favorites,
          offset: favorites.length));
    } catch (e) {
      print("Error ======================= favorites $e");
      emit(state.copyWith(status: FavoriteStatus.error));
    }
  }

  // Load more
  void loadMoreFavorites() async {
    try {
      if (state.isLoadingMore || !state.hasMore) return;

      emit(state.copyWith(isLoadingMore: true));
      final List<FavoriteEntity> favorites = await getFavoritesUsecase
          .call(FavoritesParams(userId: _userId, offset: state.offset));

      emit(state.copyWith(
          isLoadingMore: false,
          favorites: [...state.favorites, ...favorites],
          hasMore: favorites.length == 15,
          offset: state.offset + favorites.length));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  // Add to favorites
  void addToFavorites(WordEntity word) async {
    try {
      print("Add to favorites ========================= start");
      emit(state.copyWith(actionStatus: FavoriteActionStatus.loading));

      print(
          "word Favroites ================== ${word.id} ========== ${word.isFavorite}");

      // Check if wordId is Null
      if (word.id == null) {
        print("WORD ID IS NULL , ADD TO FAVROITES ========================= ");
        emit(state.copyWith(actionStatus: FavoriteActionStatus.error));
        return;
      }
      await addToFavoritesUsecase
          .call(FavoritesParams(userId: _userId, wordId: word.id));

      // Update the word
      final updatedWord = word.copyWith(isFavorite: true);
      print("Done ADD the word to favroites ===================");
      emit(state.copyWith(
          actionStatus: FavoriteActionStatus.added, word: updatedWord));
    } catch (e) {
      print("Error add to favorites =============== $e");
      emit(state.copyWith(actionStatus: FavoriteActionStatus.error));
    }
  }

  // Remove from favorites
  void removeFromFavorites(WordEntity word) async {
    try {
      emit(state.copyWith(actionStatus: FavoriteActionStatus.loading));
      print("Start removing the word from favroites ===================");

      // Check if wordId is Null
      if (word.id == null) {
        print(
            "removing the word from favroites =================== id is null ");
        emit(state.copyWith(actionStatus: FavoriteActionStatus.error));
        return;
      }
      await removeFromFavoritesUsecase
          .call(FavoritesParams(userId: _userId, wordId: word.id));

      print("Done removing the word from favroites ===================");
      // Update the word
      final updatedWord = word.copyWith(isFavorite: false);
      emit(state.copyWith(
          actionStatus: FavoriteActionStatus.removed, word: updatedWord));
    } catch (e) {
      print("Error removing the word from favroites ===================$e");
      emit(state.copyWith(actionStatus: FavoriteActionStatus.error));
    }
  }
}
