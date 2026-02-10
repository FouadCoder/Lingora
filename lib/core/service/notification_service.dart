import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final SupabaseClient _supabaseClient;
  final Box _box;

  NotificationService(this._supabaseClient, this._box);
  String? get _userId => _supabaseClient.auth.currentUser?.id;

  Future<void> login() async {
    try {
      if (_userId == null) return;
      await OneSignal.login(_userId!);
    } catch (_) {}
  }

  Future<void> logout() async {
    try {
      if (_userId == null) return;
      await OneSignal.logout();
    } catch (_) {}
  }

  Future shouldRequestNotificationPermission() async {
    try {
      int appOpenCount = await _box.get("app_open_count", defaultValue: 0);

      // If more than 3 times ask for permission
      if (appOpenCount > 3) {
        return OneSignal.Notifications.requestPermission(true);
      }
    } catch (_) {}
  }
}
