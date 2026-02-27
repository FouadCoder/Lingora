import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/exceptions/network_exception.dart';
import 'package:lingora/features/notification/domain/entities/reminder_entity.dart';
import 'package:lingora/features/notification/domain/usecases/active_reminder_usecase.dart';
import 'package:lingora/features/notification/domain/usecases/get_reminders_usecase.dart';
import 'package:lingora/features/notification/domain/usecases/params/reminder_params.dart';
import 'package:lingora/features/notification/domain/usecases/unactive_reminder_usecase.dart';
import 'package:lingora/features/notification/domain/usecases/params/notification_params.dart';
import 'package:lingora/features/notification/presentation/cubit/reminders/reminder_state.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final GetRemindersUseCase _getRemindersUseCase;
  final ActiveReminderUseCase _activeReminderUseCase;
  final UnactiveReminderUseCase _unactiveReminderUseCase;

  int _offset = 0;
  DateTime? lastRefresh;

  ReminderCubit(
    this._getRemindersUseCase,
    this._activeReminderUseCase,
    this._unactiveReminderUseCase,
  ) : super(ReminderState());

  Future<void> getReminders({bool forceRefresh = false}) async {
    // If loaded before and has notifications, or already confirmed empty
    if (!forceRefresh &&
        (state.reminders.isNotEmpty || state.status == ReminderStatus.empty)) {
      emit(
        state.copyWith(
            status: state.reminders.isNotEmpty
                ? ReminderStatus.success
                : ReminderStatus.empty,
            reminders: state.reminders,
            actionStatus: ReminderStatus.initial),
      );
      return;
    }
    _offset = 0;
    if (!forceRefresh) {
      emit(state.copyWith(
          status: ReminderStatus.loading,
          actionStatus: ReminderStatus.initial));
    }

    try {
      final reminders = await _getRemindersUseCase(
        NotificationParams(offset: _offset),
      );

      if (reminders.isEmpty) {
        emit(state.copyWith(
          status: ReminderStatus.empty,
          reminders: [],
          hasMore: false,
        ));
      } else {
        emit(state.copyWith(
          status: ReminderStatus.success,
          reminders: reminders,
          hasMore: reminders.length >= 15,
        ));
      }
    } on NetworkException {
      emit(state.copyWith(status: ReminderStatus.networkError));
    } catch (e) {
      emit(state.copyWith(status: ReminderStatus.error));
    }
  }

  Future<void> loadMoreReminders() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));
    _offset += 15;

    try {
      final reminders = await _getRemindersUseCase(
        NotificationParams(offset: _offset),
      );

      final updatedReminders = List<ReminderEntity>.from(state.reminders)
        ..addAll(reminders);

      emit(state.copyWith(
        reminders: updatedReminders,
        isLoadingMore: false,
        hasMore: reminders.length >= 15,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> activeReminder(WordEntity word) async {
    try {
      emit(state.copyWith(actionStatus: ReminderStatus.loading));
      final reminder = await _activeReminderUseCase(word);

      // Insert in list
      if (state.status == ReminderStatus.empty ||
          state.status == ReminderStatus.success) {
        emit(state.copyWith(
            actionStatus: ReminderStatus.success,
            reminders: [reminder, ...state.reminders],
            wordId: word.id,
            reminder: reminder));
      } else {
        // Success without insert on list
        emit(state.copyWith(
            actionStatus: ReminderStatus.success,
            wordId: word.id,
            reminder: reminder));
      }
    } on NetworkException {
      emit(state.copyWith(actionStatus: ReminderStatus.networkError));
    } catch (_) {
      emit(state.copyWith(actionStatus: ReminderStatus.error));
      rethrow;
    }
  }

  Future<void> unactiveReminder(String reminderId, String wordId) async {
    try {
      emit(state.copyWith(
          actionStatus: ReminderStatus.loading,
          reminderIdToRemove: reminderId));

      await _unactiveReminderUseCase(
          ReminderParams(reminderId: reminderId, isActive: false));

      // Get the wordId from the removed reminder
      bool isExistonReminderList =
          state.reminders.any((reminder) => reminder.id == reminderId);

      // Remove from list if exist
      if (isExistonReminderList) {
        final reminderToRemove =
            state.reminders.firstWhere((reminder) => reminder.id == reminderId);
        // Remove from reminders list
        final updatedReminders = state.reminders
            .where((reminder) => reminder.id != reminderId)
            .toList();

        emit(state.copyWith(
          reminders: updatedReminders,
          wordId: reminderToRemove.wordId,
          actionStatus: ReminderStatus.removed,
        ));
      }

      // If not exist
      if (!isExistonReminderList) {
        emit(state.copyWith(
          wordId: wordId,
          actionStatus: ReminderStatus.removed,
        ));
      }
    } on NetworkException {
      emit(state.copyWith(actionStatus: ReminderStatus.networkError));
    } catch (e) {
      emit(state.copyWith(actionStatus: ReminderStatus.error));
    }
  }

  Future<void> refreshReminders() async {
    DateTime now = DateTime.now();

    if (lastRefresh == null) {
      await getReminders(forceRefresh: true);
      lastRefresh = now;
      return;
    }

    int minutesLeft = now.difference(lastRefresh!).inMinutes;
    int minutesRemaining = 15 - minutesLeft;

    if (minutesLeft >= 15) {
      await getReminders(forceRefresh: true);
      lastRefresh = now;
    } else {
      emit(
        state.copyWith(
            actionStatus: ReminderStatus.limitExceeded,
            minutesLeft: minutesRemaining),
      );
    }
  }

  // Reset cubit state (for logout)
  void reset() {
    _offset = 0;
    lastRefresh = null;
    emit(ReminderState());
  }
}
