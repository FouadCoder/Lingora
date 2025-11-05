import 'package:lingora/features/library/domain/entities/word_entity.dart';

abstract class LibraryRepository {
  Future<List<WordEntity>> getLibrary();
}
