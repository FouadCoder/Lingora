import 'package:lingora/features/library/domain/entities/word_entity.dart';

enum LibraryStatus { initial, loading, success, failure, empty }

class LibraryState {
  final LibraryStatus status;
  final List<WordEntity> libraryWords;

  const LibraryState(
      {this.status = LibraryStatus.initial, this.libraryWords = const []});

  LibraryState copyWith({
    LibraryStatus? status,
    List<WordEntity>? libraryWords,
  }) {
    return LibraryState(
      status: status ?? this.status,
      libraryWords: libraryWords ?? this.libraryWords,
    );
  }
}
