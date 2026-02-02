import 'package:lingora/features/notification/data/models/notification_model.dart';
import 'package:lingora/features/notification/domain/usecases/params/notification_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(NotificationParams params);
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
}
