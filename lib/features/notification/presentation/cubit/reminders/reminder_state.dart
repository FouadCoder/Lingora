import 'package:lingora/features/notification/domain/entities/reminder_entity.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';

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
  final List<ReminderEntity> reminders;
  final bool isLoadingMore;
  final bool hasMore;
  final WordEntity? word;

  const ReminderState({
    this.status = ReminderStatus.initial,
    this.actionStatus = ReminderStatus.initial,
    this.reminders = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
    this.word,
  });

  ReminderState copyWith({
    ReminderStatus? status,
    ReminderStatus? actionStatus,
    List<ReminderEntity>? reminders,
    bool? isLoadingMore,
    bool? hasMore,
    WordEntity? word,
  }) {
    return ReminderState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      reminders: reminders ?? this.reminders,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      word: word ?? this.word,
    );
  }
}
