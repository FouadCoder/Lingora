import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/exceptions/network_exception.dart';
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

  // Get favorites
  void getFavorites() async {
    try {
      // Check if there data exist
      if (state.favorites.isNotEmpty) {
        emit(state.copyWith(
          status: FavoriteStatus.success,
          actionStatus: FavoriteActionStatus.idle,
          favorites: state.favorites,
        ));
        return;
      }

      // Get
      emit(state.copyWith(
        status: FavoriteStatus.loading,
        actionStatus: FavoriteActionStatus.idle,
      ));
      final List<FavoriteEntity> favorites =
          await getFavoritesUsecase.call(FavoritesParams(offset: 0));

      // If empty
      if (favorites.isEmpty) {
        emit(state.copyWith(status: FavoriteStatus.empty));
        return;
      }

      emit(state.copyWith(
          status: FavoriteStatus.success,
          favorites: favorites,
          offset: favorites.length));
    } on NetworkException {
      emit(state.copyWith(status: FavoriteStatus.networkError));
    } catch (e) {
      emit(state.copyWith(status: FavoriteStatus.error));
    }
  }

  // Load more
  void loadMoreFavorites() async {
    try {
      if (state.isLoadingMore || !state.hasMore) return;

      emit(state.copyWith(
        isLoadingMore: true,
        actionStatus: FavoriteActionStatus.idle,
      ));
      final List<FavoriteEntity> favorites =
          await getFavoritesUsecase.call(FavoritesParams(offset: state.offset));

      emit(state.copyWith(
          isLoadingMore: false,
          favorites: [...state.favorites, ...favorites],
          hasMore: favorites.length == 15,
          offset: state.offset + favorites.length));
    } on NetworkException {
      emit(state.copyWith(
          isLoadingMore: false, status: FavoriteStatus.networkError));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  // Add to favorites
  void addToFavorites(WordEntity word) async {
    print(
        ' =========================== FavoritesCubit.addToFavorites - wordId: ${word.id}, isFavorite: ${word.isFavorite}');
    try {
      emit(state.copyWith(actionStatus: FavoriteActionStatus.loading));

      await addToFavoritesUsecase.call(FavoritesParams(wordId: word.id));

      // Update the word
      final updatedWord = word.copyWith(isFavorite: true);
      print(
          ' ===========================FavoritesCubit.addToFavorites - SUCCESS, emitting added status');
      emit(state.copyWith(
          actionStatus: FavoriteActionStatus.added, word: updatedWord));
    } on NetworkException {
      print(
          ' ===========================FavoritesCubit.addToFavorites - NETWORK ERROR');
      emit(state.copyWith(actionStatus: FavoriteActionStatus.networkError));
    } catch (e) {
      print(
          ' ===========================FavoritesCubit.addToFavorites - ERROR: $e');
      emit(state.copyWith(actionStatus: FavoriteActionStatus.error));
    }
  }

  // Remove from favorites
  void removeFromFavorites(WordEntity word) async {
    print(
        ' =========================== FavoritesCubit.removeFromFavorites - wordId: ${word.id}, isFavorite: ${word.isFavorite}');
    try {
      emit(state.copyWith(actionStatus: FavoriteActionStatus.loading));

      await removeFromFavoritesUsecase.call(FavoritesParams(wordId: word.id));

      // Update the word
      final updatedWord = word.copyWith(isFavorite: false);
      print(
          ' =========================== FavoritesCubit.removeFromFavorites - SUCCESS, emitting removed status');
      emit(state.copyWith(
          actionStatus: FavoriteActionStatus.removed, word: updatedWord));
    } on NetworkException {
      print(
          ' =========================== FavoritesCubit.removeFromFavorites - NETWORK ERROR');
      emit(state.copyWith(actionStatus: FavoriteActionStatus.networkError));
    } catch (e) {
      print(
          ' ===========================FavoritesCubit.removeFromFavorites - ERROR: $e');
      emit(state.copyWith(actionStatus: FavoriteActionStatus.error));
    }
  }
}
