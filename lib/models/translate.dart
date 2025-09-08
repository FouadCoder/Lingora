import 'package:easy_localization/easy_localization.dart';
import 'package:lingora/data/langauges_list.dart';

class Translate {
  final String original;
  final String translated;
  final String pos; // part of speech
  final String pronunciation;
  final String meaning;
  final List<String> examples;
  final List<String> synonyms;
  final Language translateFrom;
  final Language translateTo;

  const Translate({
    required this.original,
    required this.translated,
    required this.pos,
    required this.pronunciation,
    required this.meaning,
    required this.examples,
    required this.synonyms,
    required this.translateFrom,
    required this.translateTo,
  });

  factory Translate.fromJson(Map<String, dynamic> json) {
    return Translate(
        original: json['original'] ?? "",
        translated: json['translated'] ?? "translation_not_found".tr(),
        pos: json['pos'] ?? '',
        pronunciation: json['pronunciation'] ?? '',
        meaning: json["meaning"] ?? "",
        examples: (json['examples'] as List<dynamic>?)?.cast<String>() ?? [],
        synonyms: (json['synonyms'] as List<dynamic>?)?.cast<String>() ?? [],
        translateFrom:
            json["translateFrom"] ?? LanguageData.getLanguageByCode("en"),
        translateTo:
            json["translateTo"] ?? LanguageData.getLanguageByCode("ar"));
  }
}
