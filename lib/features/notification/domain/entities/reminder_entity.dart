class ReminderEntity {
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

  ReminderEntity({
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

  ReminderEntity copyWith({
    String? id,
    String? userId,
    String? wordId,
    DateTime? remindAt,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? original,
    String? translated,
    DateTime? deletedAt,
  }) {
    return ReminderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      wordId: wordId ?? this.wordId,
      remindAt: remindAt ?? this.remindAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      original: original ?? this.original,
      translated: translated ?? this.translated,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
