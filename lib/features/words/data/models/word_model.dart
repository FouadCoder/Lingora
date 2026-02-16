import 'package:easy_localization/easy_localization.dart';
import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/notification/data/models/reminder_model.dart';
import 'package:lingora/features/words/data/models/collection_model.dart';
import 'package:lingora/features/words/data/models/note_model.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';

class WordModel {
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
  final NoteModel note;
  final CollectionModel collection;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool isFavorite;
  final ReminderModel? reminderModel;
  final bool activeReminder;

  const WordModel({
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
    required this.updatedAt,
    required this.createdAt,
    this.deletedAt,
    this.isFavorite = false,
    this.activeReminder = false,
    this.reminderModel,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      original: json['original'] ?? "",
      translated: json['translated'] ?? "translation_not_found".tr(),
      pos: json['pos'] ?? "",
      pronunciation: json['pronunciation'] ?? "",
      meaning: json["meaning"] ?? "",
      examples: (json['examples'] as List<dynamic>?)?.cast<String>() ?? [],
      synonyms: (json['synonyms'] as List<dynamic>?)?.cast<String>() ?? [],
      translateFrom: json["translate_from"] != null
          ? LanguageData.getLanguageByCode(json["translate_from"])
          : LanguageData.getLanguageByCode("en"),
      translateTo: json["translate_to"] != null
          ? LanguageData.getLanguageByCode(json["translate_to"])
          : LanguageData.getLanguageByCode("ar"),
      note: json['notes'] != null
          ? (json['notes'] is List && (json['notes'] as List).isNotEmpty
              ? NoteModel.fromJson((json['notes'] as List).first)
              : NoteModel.fromJson(json['notes'] as Map<String, dynamic>))
          : NoteModel.empty(),
      collection: json['collections'] != null
          ? (json['collections'] is List &&
                  (json['collections'] as List).isNotEmpty
              ? CollectionModel.fromJson((json['collections'] as List).first)
              : CollectionModel.fromJson(
                  json['collections'] as Map<String, dynamic>))
          : CollectionModel.empty(),
      isFavorite:
          json['favorites'] != null && (json['favorites'] as List).isNotEmpty
              ? true
              : false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at']!)
          : null,
      reminderModel: (json['reminders'] as List?)?.isNotEmpty == true
          ? ReminderModel.fromJson((json['reminders'] as List).first)
          : null,
      activeReminder: (json['reminders'] as List?)?.isNotEmpty == true,
    );
  }

  // To Entity
  WordEntity toEntity() {
    return WordEntity(
        id: id,
        userId: userId,
        categoryId: categoryId,
        original: original,
        translated: translated,
        pos: pos,
        pronunciation: pronunciation,
        meaning: meaning,
        examples: examples,
        synonyms: synonyms,
        translateFrom: translateFrom,
        translateTo: translateTo,
        note: note.toEntity(),
        collection: collection.toEntity(),
        isFavorite: isFavorite,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
        reminder: reminderModel?.toEntity(),
        activeReminder: activeReminder);
  }

  // To Empty
  factory WordModel.empty() {
    return WordModel(
      id: '',
      userId: '',
      categoryId: '',
      original: '',
      translated: '',
      pos: '',
      pronunciation: '',
      meaning: '',
      examples: const [],
      synonyms: const [],
      translateFrom: LanguageData.getLanguageByCode("en"),
      translateTo: LanguageData.getLanguageByCode("ar"),
      note: NoteModel.empty(),
      collection: CollectionModel.empty(),
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: null,
      reminderModel: null,
      activeReminder: false,
    );
  }
}
