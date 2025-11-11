import 'package:hive/hive.dart';
import 'package:lingora/features/library/data/models/collection_model.dart';

class LibraryLocalData {
  final db = Hive.box("db");

  // Save collections IDS
  Future saveCollections(List<CollectionModel> collections) async {
    List<Map<String, dynamic>> collectionsJson =
        collections.map((e) => e.toJson()).toList();
    db.put("collections", collectionsJson);
  }

  // Get collections IDS
  Future getCollections() async {
    final List<dynamic> rawData = db.get("collections", defaultValue: []);
    List<Map<String, dynamic>> collectionsJson =
        List<Map<String, dynamic>>.from(rawData);
    List<CollectionModel> collections =
        collectionsJson.map((e) => CollectionModel.fromJson(e)).toList();
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
