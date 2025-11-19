import 'package:lingora/data/langauges_list.dart';

class HistoryEntity {
  final String? id;
  final String? userId;
  final String original;
  final String translated;
  final Language translateFrom;
  final Language translateTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const HistoryEntity({
    this.id,
    this.userId,
    required this.original,
    required this.translated,
    required this.translateFrom,
    required this.translateTo,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
