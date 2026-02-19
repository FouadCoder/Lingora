import 'package:lingora/features/words/domain/entities/word_entity.dart';

enum LibraryStatus { initial, loading, success, failure, empty, networkError }

enum LibraryActionStatus {
  initial,
  loading,
  success,
  failure,
  networkError,
  limitExceeded
}

class LibraryState {
  final LibraryStatus status;
  final LibraryStatus collectionStatus;
  final LibraryActionStatus actionStatus;
  final List<WordEntity> libraryWords;
  final List<WordEntity> collectionsWords;
  final bool isLoadingMore;
  final bool hasMore;
  final bool hasMoreCollections;
  final int? minutesUntilRefresh;

  const LibraryState({
    this.status = LibraryStatus.initial,
    this.collectionStatus = LibraryStatus.initial,
    this.actionStatus = LibraryActionStatus.initial,
    this.libraryWords = const [],
    this.collectionsWords = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
    this.hasMoreCollections = true,
    this.minutesUntilRefresh,
  });

  LibraryState copyWith({
    LibraryStatus? status,
    LibraryStatus? collectionStatus,
    LibraryActionStatus? actionStatus,
    List<WordEntity>? libraryWords,
    List<WordEntity>? collectionsWords,
    bool? isLoadingMore,
    bool? hasMore,
    bool? hasMoreCollections,
    int? minutesUntilRefresh,
  }) {
    return LibraryState(
      status: status ?? this.status,
      collectionStatus: collectionStatus ?? this.collectionStatus,
      actionStatus: actionStatus ?? this.actionStatus,
      libraryWords: libraryWords ?? this.libraryWords,
      collectionsWords: collectionsWords ?? this.collectionsWords,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      hasMoreCollections: hasMoreCollections ?? this.hasMoreCollections,
      minutesUntilRefresh: minutesUntilRefresh ?? this.minutesUntilRefresh,
    );
  }
}
