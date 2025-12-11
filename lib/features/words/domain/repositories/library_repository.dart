import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/domain/usecases/collections_params.dart';
import 'package:lingora/features/words/domain/usecases/library_params.dart';

abstract class LibraryRepository {
  Future<List<WordEntity>> getLibrary(LibraryParams params);
  Future<void> updateWordCollection(CollectionsParams params);
}
