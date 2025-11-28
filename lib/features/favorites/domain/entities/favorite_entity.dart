import 'package:lingora/features/library/domain/entities/word_entity.dart';

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
}
