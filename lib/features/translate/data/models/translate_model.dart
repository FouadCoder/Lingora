import 'package:easy_localization/easy_localization.dart';
import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/translate/domain/entities/translate_entity.dart';
import 'package:lingora/features/words/data/models/collection_model.dart';

class TranslateModel {
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
  final CollectionModel collectionModel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const TranslateModel({
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
    required this.collectionModel,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory TranslateModel.fromJson(Map<String, dynamic> json) {
    return TranslateModel(
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
      collectionModel: json["collection"] != null
          ? CollectionModel.fromJson(json["collection"])
          : CollectionModel.empty(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at']!)
          : null,
    );
  }

  // Empty
  factory TranslateModel.empty() {
    return TranslateModel(
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
      collectionModel: CollectionModel.empty(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: null,
    );
  }

  // To Entity
  TranslateEntity toEntity() {
    return TranslateEntity(
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
      collection: collectionModel.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
