import 'package:lingora/features/notification/domain/entities/reminder_entity.dart';

class ReminderModel {
  final String id;
  final String userId;
  final String wordId;
  final DateTime remindAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String original;
  final String translated;

  ReminderModel({
    required this.id,
    required this.userId,
    required this.wordId,
    required this.remindAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.original,
    required this.translated,
    this.deletedAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'],
      userId: json['user_id'],
      wordId: json['word_id'],
      remindAt: DateTime.tryParse(json['remind_at']) ?? DateTime.now(),
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      original: json['translated_words']?['original'] as String? ?? '',
      translated: json['translated_words']?['translated'] as String? ?? '',
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
      deletedAt: deletedAt,
      original: original,
      translated: translated,
    );
  }
}
