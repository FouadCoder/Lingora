import 'package:lingora/features/notes/domain/note_entity.dart';

class NoteModel {
  final String? id;
  final String? wordId;
  final String? userId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const NoteModel({
    required this.id,
    required this.wordId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  /// Creates an empty note with default values
  factory NoteModel.empty() => NoteModel(
        id: null,
        wordId: null,
        userId: null,
        content: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
      );

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      wordId: json['word_id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] ?? "",
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at']!)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word_id': wordId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  NoteEntity toEntity() => NoteEntity(
        id: id,
        wordId: wordId,
        userId: userId,
        content: content,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
      );
}
