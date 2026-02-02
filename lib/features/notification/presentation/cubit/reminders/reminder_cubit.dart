import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/notification/domain/entities/reminder_entity.dart';
import 'package:lingora/features/notification/domain/usecases/active_reminder_usecase.dart';
import 'package:lingora/features/notification/domain/usecases/get_reminders_usecase.dart';
import 'package:lingora/features/notification/domain/usecases/unactive_reminder_usecase.dart';
import 'package:lingora/features/notification/domain/usecases/params/notification_params.dart';
import 'package:lingora/features/notification/presentation/cubit/reminders/reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final GetRemindersUseCase _getRemindersUseCase;
  final ActiveReminderUseCase _activeReminderUseCase;
  final UnactiveReminderUseCase _unactiveReminderUseCase;

  int _offset = 0;
  DateTime? lastRefresh;

  ReminderCubit({
    required GetRemindersUseCase getRemindersUseCase,
    required ActiveReminderUseCase activeReminderUseCase,
    required UnactiveReminderUseCase unactiveReminderUseCase,
  })  : _getRemindersUseCase = getRemindersUseCase,
        _activeReminderUseCase = activeReminderUseCase,
        _unactiveReminderUseCase = unactiveReminderUseCase,
        super(ReminderState());

  Future<void> getReminders() async {
    _offset = 0;
    emit(state.copyWith(status: ReminderStatus.loading));

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

  Future<void> activeReminder(String reminderId) async {
    try {
      await _activeReminderUseCase(reminderId);

      // Update the reminder in the local state
      final updatedReminders = state.reminders.map((reminder) {
        if (reminder.id == reminderId) {
          return reminder.copyWith(isActive: true);
        }
        return reminder;
      }).toList();

      emit(state.copyWith(reminders: updatedReminders));
    } catch (e) {
      emit(state.copyWith(status: ReminderStatus.error));
    }
  }

  Future<void> unactiveReminder(String reminderId) async {
    try {
      await _unactiveReminderUseCase(reminderId);

      // Update the reminder in the local state
      final updatedReminders = state.reminders.map((reminder) {
        // Assuming reminder has an id and isActive property
        // You'll need to adjust this based on your actual model
        if (reminder.id == reminderId) {
          return reminder.copyWith(isActive: false);
        }
        return reminder;
      }).toList();

      emit(state.copyWith(reminders: updatedReminders));
    } catch (e) {
      emit(state.copyWith(status: ReminderStatus.error));
    }
  }
}
