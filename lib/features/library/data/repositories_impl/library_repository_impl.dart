import 'package:lingora/features/library/data/datasources/library_local_data.dart';
import 'package:lingora/features/library/data/models/collection_model.dart';
import 'package:lingora/features/library/data/models/word_model.dart';
import 'package:lingora/features/library/domain/entities/word_entity.dart';
import 'package:lingora/features/library/data/datasources/library_remote_data.dart';
import 'package:lingora/features/library/domain/repositories/library_repository.dart';
import 'package:lingora/features/library/domain/usecases/collections_params.dart';
import 'package:lingora/features/library/domain/usecases/library_params.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteData libraryRemoteData;
  final LibraryLocalData libraryLocalData;
  LibraryRepositoryImpl(this.libraryRemoteData, this.libraryLocalData);

  @override
  Future<List<WordEntity>> getLibrary(LibraryParams params) async {
    List<WordModel> libraryWords = await libraryRemoteData.getLibrary(params);
    List<WordEntity> libraryWordsEntity =
        libraryWords.map((e) => e.toEntity()).toList();
    return libraryWordsEntity;
  }

  Future<String?> getCollectionId(String collectionName) async {
    // Get last updated time
    DateTime lastUpdatedTime =
        await libraryLocalData.getLastUpdatedTimeCollections();
    DateTime now = DateTime.now();
    Duration difference = now.difference(lastUpdatedTime);
    bool isRequestFromServer = difference.inDays > 7;
    List<CollectionModel> collectionsModel = [];

    // Get from server if last updated time was more than 7 days
    if (isRequestFromServer) {
      collectionsModel = await libraryRemoteData.getCollections();
    } else {
      collectionsModel = await libraryLocalData.getCollections();
    }

    if (isRequestFromServer) {
      await libraryLocalData.saveCollections(collectionsModel);
      await libraryLocalData.saveLastUpdatedTimeCollections(now);
    }

    // Get collection id
    String? collectionId =
        collectionsModel.firstWhere((e) => e.name == collectionName).id;

    return collectionId;
  }

  @override
  Future<void> updateWordCollection(CollectionsParams params) async {
    String? collectionId = await getCollectionId(params.collectionName);
    if (collectionId == null) {
      throw Exception("Collection not found");
    }
    // Update word collection
    await libraryRemoteData.updateWordCollection(CollectionsParams(
        collectionId: collectionId,
        wordId: params.wordId,
        collectionName: params.collectionName));
  }
}
