import 'package:lingora/features/words/domain/entities/word_entity.dart';

enum NotesStatus { initial, loading, success, failure, empty }

class NotesState {
  final NotesStatus status;
  final WordEntity? word;
  NotesState({this.status = NotesStatus.initial, this.word});

  NotesState copyWith({
    NotesStatus? status,
    WordEntity? word,
  }) {
    return NotesState(status: status ?? this.status, word: word ?? this.word);
  }
}
