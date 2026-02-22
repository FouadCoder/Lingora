import 'package:lingora/features/notification/domain/entities/notification_entity.dart';
import 'package:lingora/features/notification/domain/repositories/notification_repository.dart';
import 'package:lingora/features/notification/domain/usecases/params/notification_params.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call(NotificationParams params) {
    return repository.getNotifications(params);
  }
}
