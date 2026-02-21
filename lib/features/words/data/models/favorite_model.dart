import 'package:lingora/features/words/domain/entities/favorite_entity.dart';
import 'package:lingora/features/words/data/models/word_model.dart';

class FavoriteModel {
  final String id;
  final String userId;
  final String wordId;
  final DateTime createdAt;
  final WordModel word;

  const FavoriteModel({
    required this.id,
    required this.userId,
    required this.wordId,
    required this.createdAt,
    required this.word,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      wordId: json['word_id'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      word: json['translated_words'] != null
          ? WordModel.fromJson(json['translated_words'])
          : WordModel.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'word_id': wordId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  FavoriteModel copyWith({
    String? id,
    String? userId,
    String? wordId,
    DateTime? createdAt,
    WordModel? word,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      wordId: wordId ?? this.wordId,
      createdAt: createdAt ?? this.createdAt,
      word: word ?? this.word,
    );
  }

  FavoriteEntity toEntity() {
    return FavoriteEntity(
      id: id,
      userId: userId,
      wordId: wordId,
      createdAt: createdAt,
      word: word.toEntity(),
    );
  }
}
