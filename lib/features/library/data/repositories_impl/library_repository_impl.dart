import 'package:lingora/features/library/data/models/word_model.dart';
import 'package:lingora/features/library/domain/entities/word_entity.dart';
import 'package:lingora/features/library/data/datasources/library_remote_data.dart';
import 'package:lingora/features/library/domain/repositories/library_repository.dart';
import 'package:lingora/features/library/domain/usecases/library_params.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteData libraryRemoteData;
  LibraryRepositoryImpl(this.libraryRemoteData);

  @override
  Future<List<WordEntity>> getLibrary(LibraryParams params) async {
    List<WordModel> libraryWords = await libraryRemoteData.getLibrary(params);
    List<WordEntity> libraryWordsEntity =
        libraryWords.map((e) => e.toEntity()).toList();
    return libraryWordsEntity;
  }
}
