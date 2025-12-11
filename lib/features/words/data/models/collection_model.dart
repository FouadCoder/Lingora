import 'package:lingora/features/words/domain/entities/collection_entity.dart';

class CollectionModel {
  final String? id;
  final String name;
  final int wordCount;

  CollectionModel({this.id, required this.name, required this.wordCount});

  CollectionModel.empty() : this(id: null, name: '', wordCount: 0);

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'],
      name: json['name'] ?? '',
      wordCount: json["word_count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'word_count': wordCount,
    };
  }

  CollectionEntity toEntity() {
    return CollectionEntity(id: id, name: name, wordCount: wordCount);
  }
}
