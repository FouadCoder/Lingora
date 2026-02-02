import 'package:lingora/features/notification/data/models/notification_model.dart';
import 'package:lingora/features/notification/data/models/reminder_model.dart';
import 'package:lingora/features/notification/domain/usecases/params/notification_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(NotificationParams params);
  Future<List<ReminderModel>> getReminders(NotificationParams params);
  Future<void> activeReminder(String reminderId);
  Future<void> unactiveReminder(String reminderId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final SupabaseClient _supabaseClient;

  NotificationRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<List<NotificationModel>> getNotifications(
    NotificationParams params,
  ) async {
    final data = await _supabaseClient
        .from('notifications')
        .select()
        .order('created_at', ascending: false)
        .range(params.offset, params.offset + 15 - 1);
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  @override
  Future<List<ReminderModel>> getReminders(
    NotificationParams params,
  ) async {
    // TODO: Implement getReminders logic
    // This will fetch reminders from your database
    // You can customize the query to filter reminders specifically
    throw UnimplementedError('getReminders not implemented yet');
  }

  @override
  Future<void> activeReminder(String reminderId) async {
    // TODO: Implement activeReminder logic
    // This will activate a reminder in your database
    throw UnimplementedError('activeReminder not implemented yet');
  }

  @override
  Future<void> unactiveReminder(String reminderId) async {
    // TODO: Implement unactiveReminder logic
    // This will deactivate a reminder in your database
    throw UnimplementedError('unactiveReminder not implemented yet');
  }
}
