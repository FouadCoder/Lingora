import 'package:easy_localization/easy_localization.dart';
import 'package:lingora/data/langauges_list.dart';

class Translate {
  final String id;
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Translate({
    required this.id,
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
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Translate.fromJson(Map<String, dynamic> json) {
    return Translate(
      id: json['id'] ?? '',
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
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at']!)
          : null,
    );
  }
}
