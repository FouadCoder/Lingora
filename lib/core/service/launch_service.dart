import 'package:hive/hive.dart';
import 'package:lingora/core/service/notification_service.dart';

class LaunchService {
  final Box _box;
  final NotificationService _notificationService;

  LaunchService(this._box, this._notificationService);

  Future launch() async {
    try {
      await incrementAppOpenCount();
      await _notificationService.login();
      await _notificationService.shouldRequestNotificationPermission();
    } catch (_) {}
  }

  Future incrementAppOpenCount() async {
    try {
      print("Incrementing app open count =-========================");
      int appOpenCount = await _box.get("app_open_count", defaultValue: 0);
      await _box.put('app_open_count', appOpenCount + 1);
    } catch (_) {}
  }

  Future<int> getAppOpenCount() async {
    int appOpenCount = await _box.get("app_open_count", defaultValue: 0);
    return appOpenCount;
  }
}
