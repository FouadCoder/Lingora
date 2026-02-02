import 'package:supabase_flutter/supabase_flutter.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(NotificationParams params);
  Future<void> createNotification(CreateNotificationParams params);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final SupabaseClient _supabaseClient;

  NotificationRemoteDataSourceImpl(this._supabaseClient);

  // String get _userId => _supabaseClient.auth.currentUser!.id;
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
  Future<void> createNotification(CreateNotificationParams params) async {
    await _supabaseClient.functions.invoke(
      'admin_notification',
      body: {
        'adminId': 'uuid', // Static UUID for now
        'title': params.title,
        'message': params.message,
        'icon': params.icon ?? 'bell',
      },
    );
  }
}
