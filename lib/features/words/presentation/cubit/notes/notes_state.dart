enum NotesStatus { initial, loading, success, failure, empty }

class NotesState {
  final NotesStatus status;

  NotesState({this.status = NotesStatus.initial});

  NotesState copyWith({
    NotesStatus? status,
  }) {
    return NotesState(status: status ?? this.status);
  }
}
