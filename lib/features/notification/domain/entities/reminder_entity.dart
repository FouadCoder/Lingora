class ReminderEntity {
  final String id;
  final String userId;
  final String wordId;
  final DateTime remindAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  ReminderEntity({
    required this.id,
    required this.userId,
    required this.wordId,
    required this.remindAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
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
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
