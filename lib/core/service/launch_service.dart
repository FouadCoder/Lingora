import 'package:hive/hive.dart';
import 'package:lingora/core/service/notification_service.dart';

class LaunchService {
  final Box _box;
  final NotificationService _notificationService;

  LaunchService(this._box, this._notificationService);

  Future launch() async {
    try {
      await incrementAppOpenCount();
      await saveFirstUserOpenTime();
      await _notificationService.login();
      await _notificationService.shouldRequestNotificationPermission();
    } catch (_) {}
  }

  Future<void> incrementAppOpenCount() async {
    try {
      int appOpenCount = await _box.get("app_open_count", defaultValue: 0);
      await _box.put('app_open_count', appOpenCount + 1);
    } catch (_) {}
  }

  Future<int> getAppOpenCount() async {
    int appOpenCount = await _box.get("app_open_count", defaultValue: 0);
    return appOpenCount;
  }

  Future<void> saveFirstUserOpenTime() async {
    try {
      int openAppCount = await getAppOpenCount();
      if (openAppCount == 1) {
        await _box.put('first_user_open_time', DateTime.now());
      }
    } catch (_) {}
  }

  Future<DateTime> getFirstUserOpenTime() async {
    try {
      final firstOpenTime =
          await _box.get("first_user_open_time", defaultValue: DateTime.now());
      return firstOpenTime;
    } catch (_) {
      return DateTime.now();
    }
  }
}
