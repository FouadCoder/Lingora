import 'package:lingora/core/exceptions/network_exception.dart';
import 'package:lingora/core/service/network_service.dart';
import 'package:lingora/features/notification/data/datasources/notification_remote_data.dart';
import 'package:lingora/features/notification/domain/entities/notification_entity.dart';
import 'package:lingora/features/notification/domain/entities/reminder_entity.dart';
import 'package:lingora/features/notification/domain/repositories/notification_repository.dart';
import 'package:lingora/features/notification/domain/usecases/params/notification_params.dart';
import 'package:lingora/features/notification/domain/usecases/params/reminder_params.dart';

class NotificationRepositoriesImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoriesImpl(this._remoteDataSource);

  @override
  Future<List<NotificationEntity>> getNotifications(
    NotificationParams params,
  ) async {
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    // Call
    final models = await _remoteDataSource.getNotifications(params);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ReminderEntity>> getReminders(
    NotificationParams params,
  ) async {
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    // Call
    final models = await _remoteDataSource.getReminders(params);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ReminderEntity> activeReminder(ReminderParams params) async {
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    // Call and get the created reminder
    final reminderModel = await _remoteDataSource.activeReminder(params);
    return reminderModel.toEntity();
  }

  @override
  Future<void> unactiveReminder(ReminderParams params) async {
    // Check Internet
    if (!await NetworkService().isConnect()) {
      throw NetworkException();
    }

    // Call
    await _remoteDataSource.unactiveReminder(params);
  }
}
