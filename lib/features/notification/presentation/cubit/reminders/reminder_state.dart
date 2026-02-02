enum ReminderStatus {
  initial,
  loading,
  success,
  error,
  empty,
  networkError,
  validationError,
  limitExceeded,
}

class ReminderState {
  final ReminderStatus status;
  final ReminderStatus actionStatus;
  final List reminders;
  final bool isLoadingMore;
  final bool hasMore;

  const ReminderState({
    this.status = ReminderStatus.initial,
    this.actionStatus = ReminderStatus.initial,
    this.reminders = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  ReminderState copyWith({
    ReminderStatus? status,
    ReminderStatus? actionStatus,
    List? reminders,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return ReminderState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      reminders: reminders ?? this.reminders,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
