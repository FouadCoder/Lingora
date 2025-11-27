import 'package:lingora/features/favorites/domain/entities/favorite_entity.dart';
import 'package:lingora/features/translate/data/models/translate_model.dart';

class FavoriteModel {
  final String id;
  final String userId;
  final String translatedWordId;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final TranslateModel translatedWord;

  const FavoriteModel({
    required this.id,
    required this.userId,
    required this.translatedWordId,
    required this.createdAt,
    this.deletedAt,
    required this.translatedWord,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      translatedWordId: json['translated_word_id'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at']!)
          : null,
      translatedWord: json['translated_words'] != null
          ? TranslateModel.fromJson(json['translated_words'])
          : TranslateModel.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'translated_word_id': translatedWordId,
      'created_at': createdAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  FavoriteModel copyWith({
    String? id,
    String? userId,
    String? translatedWordId,
    DateTime? createdAt,
    DateTime? deletedAt,
    TranslateModel? translatedWord,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      translatedWordId: translatedWordId ?? this.translatedWordId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      translatedWord: translatedWord ?? this.translatedWord,
    );
  }

  FavoriteEntity toEntity() {
    return FavoriteEntity(
      id: id,
      userId: userId,
      translatedWordId: translatedWordId,
      createdAt: createdAt,
      deletedAt: deletedAt,
      translatedWord: translatedWord.toEntity(),
    );
  }
}
