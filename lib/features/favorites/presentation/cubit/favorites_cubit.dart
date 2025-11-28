import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/favorites/domain/entities/favorite_entity.dart';
import 'package:lingora/features/favorites/domain/usecases/add_to_favorites_usecase.dart';
import 'package:lingora/features/favorites/domain/usecases/favorites_params.dart';
import 'package:lingora/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:lingora/features/favorites/domain/usecases/remove_from_favorites_usecase.dart';
import 'package:lingora/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final SupabaseClient supabaseClient;
  final GetFavoritesUsecase getFavoritesUsecase;
  final AddToFavoritesUsecase addToFavoritesUsecase;
  final RemoveFromFavoritesUsecase removeFromFavoritesUsecase;
  FavoritesCubit(this.supabaseClient, this.getFavoritesUsecase,
      this.addToFavoritesUsecase, this.removeFromFavoritesUsecase)
      : super(FavoritesState());

  String get _userId => supabaseClient.auth.currentUser!.id;

  // Get favorites
  void getFavorites() async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading));
      final List<FavoriteEntity> favorites =
          await getFavoritesUsecase.call(FavoritesParams(userId: _userId));

      // If empty
      if (favorites.isEmpty) {
        emit(state.copyWith(status: FavoriteStatus.empty));
        return;
      }

      emit(
          state.copyWith(status: FavoriteStatus.success, favorites: favorites));
    } catch (_) {
      emit(state.copyWith(status: FavoriteStatus.error));
    }
  }

  // Add to favorites
  void addToFavorites(String wordId) async {
    try {
      emit(state.copyWith(actionStatus: FavoriteActionStatus.loading));
      await addToFavoritesUsecase
          .call(FavoritesParams(userId: _userId, wordId: wordId));
      emit(state.copyWith(actionStatus: FavoriteActionStatus.added));
    } catch (_) {
      emit(state.copyWith(actionStatus: FavoriteActionStatus.error));
    }
  }

  // Remove from favorites
  void removeFromFavorites(String wordId) async {
    try {
      emit(state.copyWith(actionStatus: FavoriteActionStatus.loading));
      await removeFromFavoritesUsecase
          .call(FavoritesParams(userId: _userId, wordId: wordId));
      emit(state.copyWith(actionStatus: FavoriteActionStatus.removed));
    } catch (_) {
      emit(state.copyWith(actionStatus: FavoriteActionStatus.error));
    }
  }
}
