import 'package:lingora/features/notification/domain/repositories/notification_repository.dart';

class ActiveReminderUseCase {
  final NotificationRepository repository;

  ActiveReminderUseCase(this.repository);

  Future<void> call(String reminderId) {
    return repository.activeReminder(reminderId);
  }
}
