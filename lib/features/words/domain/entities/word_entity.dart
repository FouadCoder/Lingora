import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/notification/domain/entities/reminder_entity.dart';
import 'package:lingora/features/words/domain/entities/collection_entity.dart';
import 'package:lingora/features/words/domain/entities/note_entity.dart';

class WordEntity {
  final String id;
  final String userId;
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isFavorite;
  final NoteEntity note;
  final CollectionEntity collection;
  final ReminderEntity? reminder;
  final bool activeReminder;

  const WordEntity({
    required this.id,
    required this.userId,
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
    required this.collection,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.isFavorite = false,
    this.reminder,
    this.activeReminder = false,
  });

  WordEntity copyWith({
    String? id,
    String? userId,
    String? categoryId,
    String? original,
    String? translated,
    String? pos,
    String? pronunciation,
    String? meaning,
    List<String>? examples,
    List<String>? synonyms,
    Language? translateFrom,
    Language? translateTo,
    NoteEntity? note,
    CollectionEntity? collection,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool? isFavorite,
    ReminderEntity? reminder,
    bool? activeReminder,
  }) {
    return WordEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      original: original ?? this.original,
      translated: translated ?? this.translated,
      pos: pos ?? this.pos,
      pronunciation: pronunciation ?? this.pronunciation,
      meaning: meaning ?? this.meaning,
      examples: examples ?? this.examples,
      synonyms: synonyms ?? this.synonyms,
      translateFrom: translateFrom ?? this.translateFrom,
      translateTo: translateTo ?? this.translateTo,
      note: note ?? this.note,
      collection: collection ?? this.collection,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      reminder: reminder ?? this.reminder,
      activeReminder: activeReminder ?? this.activeReminder,
    );
  }
}
