import 'package:lingora/models/translate.dart';

class Favorite {
  final String id;
  final String userId;
  final String translatedWordId;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final Translate? translatedWord; // Joined data from translated_words table

  const Favorite({
    required this.id,
    required this.userId,
    required this.translatedWordId,
    required this.createdAt,
    this.deletedAt,
    this.translatedWord,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      translatedWordId: json['translated_word_id'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at']!)
          : null,
      translatedWord: json['translated_words'] != null
          ? Translate.fromJson(json['translated_words'])
          : null,
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

  Favorite copyWith({
    String? id,
    String? userId,
    String? translatedWordId,
    DateTime? createdAt,
    DateTime? deletedAt,
    Translate? translatedWord,
  }) {
    return Favorite(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      translatedWordId: translatedWordId ?? this.translatedWordId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      translatedWord: translatedWord ?? this.translatedWord,
    );
  }
}
