import 'package:lingora/models/translate.dart';

enum LibraryStatus { initial, loading, success, failure, empty }

class LibraryState {
  final LibraryStatus status;
  final List<Translate> libraryWords;

  const LibraryState(
      {this.status = LibraryStatus.initial, this.libraryWords = const []});

  LibraryState copyWith({
    LibraryStatus? status,
    List<Translate>? libraryWords,
  }) {
    return LibraryState(
      status: status ?? this.status,
      libraryWords: libraryWords ?? this.libraryWords,
    );
  }
}
