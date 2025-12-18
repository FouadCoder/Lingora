import 'package:lingora/features/words/domain/enums/collection_enum.dart';

class CollectionEntity {
  final String id;
  final String name;
  final CollectionType collectionType;
  final int wordCount;

  CollectionEntity(
      {required this.id,
      required this.name,
      required this.wordCount,
      required this.collectionType});
}
