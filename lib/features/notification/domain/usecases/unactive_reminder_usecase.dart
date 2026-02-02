import 'package:lingora/features/notification/domain/repositories/notification_repository.dart';

class UnactiveReminderUseCase {
  final NotificationRepository repository;

  UnactiveReminderUseCase(this.repository);

  Future<void> call(String reminderId) {
    return repository.unactiveReminder(reminderId);
  }
}
