import 'package:lingora/features/translate/domain/entities/translate_entity.dart';

class FavoriteEntity {
  final String id;
  final String userId;
  final String translatedWordId;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final TranslateEntity translatedWord;

  const FavoriteEntity({
    required this.id,
    required this.userId,
    required this.translatedWordId,
    required this.createdAt,
    this.deletedAt,
    required this.translatedWord,
  });
}
