import 'package:lingora/features/notification/domain/entities/reminder_entity.dart';

enum ReminderStatus {
  initial,
  loading,
  success,
  removed,
  error,
  empty,
  networkError,
  validationError,
  limitExceeded,
}

class ReminderState {
  final ReminderStatus status;
  final ReminderStatus actionStatus;
  final List<ReminderEntity> reminders;
  final ReminderEntity? reminder;
  final bool isLoadingMore;
  final bool hasMore;
  final String? wordId;
  final String? reminderIdToRemove;

  const ReminderState(
      {this.status = ReminderStatus.initial,
      this.actionStatus = ReminderStatus.initial,
      this.reminders = const [],
      this.reminder,
      this.isLoadingMore = false,
      this.hasMore = true,
      this.wordId,
      this.reminderIdToRemove});

  ReminderState copyWith({
    ReminderStatus? status,
    ReminderStatus? actionStatus,
    List<ReminderEntity>? reminders,
    ReminderEntity? reminder,
    bool? isLoadingMore,
    bool? hasMore,
    String? wordId,
    String? reminderIdToRemove,
  }) {
    return ReminderState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      reminders: reminders ?? this.reminders,
      reminder: reminder ?? this.reminder,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      wordId: wordId ?? this.wordId,
      reminderIdToRemove: reminderIdToRemove ?? this.reminderIdToRemove,
    );
  }
}
