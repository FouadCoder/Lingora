class FavoritesParams {
  final String userId;
  final String? wordId;
  final int offset;
  FavoritesParams({required this.userId, this.wordId, this.offset = 0});
}
