import 'package:lingora/features/translate/domain/entities/translate_entity.dart';

abstract class LibraryRepository {
  Future<List<TranslateEntity>> getLibrary();
}
