import 'package:lingora/features/notification/domain/entities/reminder_entity.dart';
import 'package:lingora/features/notification/domain/repositories/notification_repository.dart';
import 'package:lingora/features/notification/domain/usecases/params/notification_params.dart';

class GetRemindersUseCase {
  final NotificationRepository repository;

  GetRemindersUseCase(this.repository);

  Future<List<ReminderEntity>> call(NotificationParams params) {
    return repository.getReminders(params);
  }
}
