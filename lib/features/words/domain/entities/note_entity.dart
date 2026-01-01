class NoteEntity {
  final String? id;
  final String? wordId;
  final String? userId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const NoteEntity({
    this.id,
    this.wordId,
    this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
