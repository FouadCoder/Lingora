import 'package:lingora/features/notification/domain/entities/reminder_entity.dart';
import 'package:lingora/features/words/data/models/word_model.dart';

class ReminderModel {
  final String id;
  final String userId;
  final String wordId;
  final DateTime remindAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final WordModel word;

  ReminderModel({
    required this.id,
    required this.userId,
    required this.wordId,
    required this.remindAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.word,
    this.deletedAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      userId: json['user_id'],
      wordId: json['word_id'],
      remindAt: DateTime.parse(json['remind_at']),
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      word: WordModel.fromJson(json['translated_words']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'word_id': wordId,
      'remind_at': remindAt.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  ReminderEntity toEntity() {
    return ReminderEntity(
      id: id,
      userId: userId,
      wordId: wordId,
      remindAt: remindAt,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      word: word.toEntity(),
      deletedAt: deletedAt,
    );
  }
}
