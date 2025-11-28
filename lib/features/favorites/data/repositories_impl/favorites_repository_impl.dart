import 'package:lingora/features/favorites/data/datasources/favorites_remote_data.dart';
import 'package:lingora/features/favorites/data/models/favorite_model.dart';
import 'package:lingora/features/favorites/domain/entities/favorite_entity.dart';
import 'package:lingora/features/favorites/domain/repositories/favorites_repositories.dart';
import 'package:lingora/features/favorites/domain/usecases/favorites_params.dart';

class FavoritesRepositoryImpl implements FavoritesRepositories {
  final FavoritesRemoteData favoritesRemoteData;

  FavoritesRepositoryImpl(this.favoritesRemoteData);

  @override
  Future<void> addToFavorites(FavoritesParams params) async {
    return await favoritesRemoteData.addToFavorites(params);
  }

  @override
  Future<List<FavoriteEntity>> getFavorites(FavoritesParams params) async {
    List<FavoriteModel> data = await favoritesRemoteData.getFavorites(params);
    List<FavoriteEntity> favorites = data.map((e) => e.toEntity()).toList();
    return favorites;
  }

  @override
  Future<void> removeFromFavorites(FavoritesParams params) async {
    return await favoritesRemoteData.removeFromFavorites(params);
  }
}
