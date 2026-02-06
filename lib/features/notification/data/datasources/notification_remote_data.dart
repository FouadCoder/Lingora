import 'package:lingora/features/notification/data/models/notification_model.dart';
import 'package:lingora/features/notification/data/models/reminder_model.dart';
import 'package:lingora/features/notification/domain/usecases/params/notification_params.dart';
import 'package:lingora/features/notification/domain/usecases/params/reminder_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(NotificationParams params);
  Future<List<ReminderModel>> getReminders(NotificationParams params);
  Future<void> activeReminder(ReminderParams params);
  Future<void> unactiveReminder(ReminderParams params);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final SupabaseClient _supabaseClient;

  NotificationRemoteDataSourceImpl(this._supabaseClient);

  String get _userId => _supabaseClient.auth.currentUser!.id;

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
    final data = await _supabaseClient
        .from('reminders')
        .select('translated_words(*)')
        .eq("user_id", _userId)
        .order('created_at', ascending: false)
        .range(params.offset, params.offset + 15 - 1);
    return data.map((json) => ReminderModel.fromJson(json)).toList();
  }

  @override
  Future<void> activeReminder(ReminderParams params) async {
    await _supabaseClient.functions.invoke('reminders', body: {
      'userId': _userId,
      'title': params.title,
      'message': params.message,
      'wordId': params.wordId,
      'remindAt': params.remindAt,
      'isActive': true
    });
  }

  @override
  Future<void> unactiveReminder(ReminderParams params) async {
    await _supabaseClient.functions.invoke('reminders', body: {
      'userId': _userId,
      'reminderId': params.reminderId,
      'isActive': false
    });
  }
}
