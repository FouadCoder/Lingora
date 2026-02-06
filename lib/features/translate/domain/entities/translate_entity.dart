import 'package:lingora/data/langauges_list.dart';

class TranslateEntity {
  final String id;
  final String userId;
  final String? collectionId;
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

  const TranslateEntity({
    required this.id,
    required this.userId,
    this.collectionId,
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
}
