import 'package:lingora/features/notification/domain/entities/notification_entity.dart';
import 'package:lingora/features/notification/domain/entities/reminder_entity.dart';
import 'package:lingora/features/notification/domain/usecases/params/notification_params.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications(NotificationParams params);
  Future<List<ReminderEntity>> getReminders(NotificationParams params);
  Future<void> activeReminder(String reminderId);
  Future<void> unactiveReminder(String reminderId);
}
