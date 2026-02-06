import 'package:lingora/features/notification/domain/repositories/notification_repository.dart';
import 'package:lingora/features/notification/domain/usecases/params/reminder_params.dart';

class UnactiveReminderUseCase {
  final NotificationRepository repository;

  UnactiveReminderUseCase(this.repository);

  Future<void> call(ReminderParams params) {
    return repository.unactiveReminder(params);
  }
}
