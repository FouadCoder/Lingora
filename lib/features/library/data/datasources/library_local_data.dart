import 'package:hive/hive.dart';
import 'package:lingora/features/library/data/models/collection_model.dart';

class LibraryLocalData {
  final db = Hive.box("db");

  // Save collections IDS
  Future saveCollections(List<CollectionModel> collections) async {
    final collectionsJson = collections.map((e) => e.toJson()).toList();
    db.put("collections", collectionsJson);
  }

  // Get Collections IDS
  Future<List<CollectionModel>> getCollections() async {
    final rawData = db.get("collections", defaultValue: []) as List;
    List<CollectionModel> collections = rawData
        .map((e) => CollectionModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return collections;
  }

  // Save last updated time collections
  Future saveLastUpdatedTimeCollections(DateTime time) async {
    db.put("lastUpdatedTimeCollections", time);
  }

  // Get last updated time collections
  Future getLastUpdatedTimeCollections() async {
    return db.get("lastUpdatedTimeCollections",
        defaultValue: DateTime(2020, 1, 1));
  }
}
