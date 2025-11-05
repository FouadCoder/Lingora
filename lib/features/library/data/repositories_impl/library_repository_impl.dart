import 'package:lingora/features/translate/domain/entities/translate_entity.dart';
import 'package:lingora/features/translate/data/models/translate_model.dart';
import 'package:lingora/features/library/data/datasources/library_remote_data.dart';
import 'package:lingora/features/library/domain/repositories/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteData libraryRemoteData;
  LibraryRepositoryImpl(this.libraryRemoteData);

  @override
  Future<List<TranslateEntity>> getLibrary() async {
    List<TranslateModel> libraryWords = await libraryRemoteData.getLibrary();
    List<TranslateEntity> libraryWordsEntity =
        libraryWords.map((e) => e.toEntity()).toList();
    return libraryWordsEntity;
  }
}
