import 'package:lingora/features/library/domain/entities/word_entity.dart';
import 'package:lingora/features/library/domain/usecases/collections_params.dart';
import 'package:lingora/features/library/domain/usecases/library_params.dart';

abstract class LibraryRepository {
  Future<List<WordEntity>> getLibrary(LibraryParams params);
  Future<void> updateWordCollection(CollectionsParams params);
}
