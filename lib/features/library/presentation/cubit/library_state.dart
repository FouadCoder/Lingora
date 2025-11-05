import 'package:lingora/features/translate/domain/entities/translate_entity.dart';

enum LibraryStatus { initial, loading, success, failure, empty }

class LibraryState {
  final LibraryStatus status;
  final List<TranslateEntity> libraryWords;

  const LibraryState(
      {this.status = LibraryStatus.initial, this.libraryWords = const []});

  LibraryState copyWith({
    LibraryStatus? status,
    List<TranslateEntity>? libraryWords,
  }) {
    return LibraryState(
      status: status ?? this.status,
      libraryWords: libraryWords ?? this.libraryWords,
    );
  }
}
