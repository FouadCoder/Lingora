import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/notes/domain/entities/note_entity.dart';

class WordEntity {
  final String? id;
  final String? userId;
  final String? categoryId;
  final String original;
  final String translated;
  final String pos;
  final String pronunciation;
  final String meaning;
  final List<String> examples;
  final List<String> synonyms;
  final Language? translateFrom;
  final Language? translateTo;
  final NoteEntity note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const WordEntity({
    this.id,
    this.userId,
    this.categoryId,
    required this.original,
    required this.translated,
    required this.pos,
    required this.pronunciation,
    required this.meaning,
    this.examples = const [],
    this.synonyms = const [],
    required this.translateFrom,
    required this.translateTo,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
