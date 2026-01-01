import 'package:lingora/features/words/domain/entities/word_entity.dart';

class FavoriteEntity {
  final String id;
  final String userId;
  final String translatedWordId;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final WordEntity word;

  const FavoriteEntity({
    required this.id,
    required this.userId,
    required this.translatedWordId,
    required this.createdAt,
    this.deletedAt,
    required this.word,
  });

  FavoriteEntity copyWith({
    String? id,
    String? userId,
    String? translatedWordId,
    DateTime? createdAt,
    DateTime? deletedAt,
    WordEntity? word,
  }) {
    return FavoriteEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      translatedWordId: translatedWordId ?? this.translatedWordId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      word: word ?? this.word,
    );
  }
}
