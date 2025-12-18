import 'package:lingora/features/words/domain/entities/collection_entity.dart';
import 'package:lingora/features/words/domain/enums/collection_enum.dart';

class CollectionModel {
  final String id;
  final String name;
  final String collectionType;
  final int wordCount;

  CollectionModel(
      {required this.id,
      required this.name,
      required this.wordCount,
      required this.collectionType});

  CollectionModel.empty()
      : this(id: '', name: '', wordCount: 0, collectionType: '');

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'],
      name: json['name'] ?? '',
      wordCount: json["word_count"] ?? 0,
      collectionType: json['collection_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'collection_type': collectionType,
      'word_count': wordCount,
    };
  }

  CollectionEntity toEntity() {
    return CollectionEntity(
        id: id,
        name: name,
        wordCount: wordCount,
        collectionType: CollectionTypeExt.fromString(collectionType));
  }
}
