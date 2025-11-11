import 'package:lingora/features/library/domain/entities/word_entity.dart';

enum LibraryStatus { initial, loading, success, failure, empty }

enum LibraryActionStatus { initial, loading, success, failure }

class LibraryState {
  final LibraryStatus status;
  final LibraryActionStatus actionStatus;
  final List<WordEntity> libraryWords;
  final bool isLoadingMore;
  final bool hasMore;

  const LibraryState(
      {this.status = LibraryStatus.initial,
      this.actionStatus = LibraryActionStatus.initial,
      this.libraryWords = const [],
      this.isLoadingMore = false,
      this.hasMore = true});

  LibraryState copyWith({
    LibraryStatus? status,
    LibraryActionStatus? actionStatus,
    List<WordEntity>? libraryWords,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return LibraryState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      libraryWords: libraryWords ?? this.libraryWords,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
