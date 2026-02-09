import 'package:hive/hive.dart';
import 'package:lingora/core/service/notification_service.dart';
import 'package:lingora/features/auth/presentation/cubit/auth_cubit.dart';

class LaunchService {
  final Box _box;
  final NotificationService _notificationService;
  final AuthCubit _authCubit;

  LaunchService(this._box, this._notificationService, this._authCubit);

  Future launch() async {
    try {
      await incrementAppOpenCount();
      await _authCubit.checkSession();
      await _notificationService.login();
      await _notificationService.shouldRequestNotificationPermission();
    } catch (_) {}
  }

  Future incrementAppOpenCount() async {
    try {
      int appOpenCount = await _box.get("app_open_count", defaultValue: 0);
      await _box.put('app_open_count', appOpenCount);
    } catch (_) {}
  }

  Future<int> getAppOpenCount() async {
    int appOpenCount = await _box.get("app_open_count", defaultValue: 1);
    return appOpenCount;
  }
}
