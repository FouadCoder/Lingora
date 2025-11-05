import 'package:lingora/features/library/data/models/word_model.dart';
import 'package:lingora/features/library/domain/entities/word_entity.dart';
import 'package:lingora/features/library/data/datasources/library_remote_data.dart';
import 'package:lingora/features/library/domain/repositories/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteData libraryRemoteData;
  LibraryRepositoryImpl(this.libraryRemoteData);

  @override
  Future<List<WordEntity>> getLibrary() async {
    List<WordModel> libraryWords = await libraryRemoteData.getLibrary();
    List<WordEntity> libraryWordsEntity =
        libraryWords.map((e) => e.toEntity()).toList();
    return libraryWordsEntity;
  }
}
