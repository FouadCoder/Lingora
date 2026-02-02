import 'package:go_router/go_router.dart';
import 'package:lingora/features/notification/presentation/pages/notification_screen.dart';

final notificationRoutes = [
  GoRoute(
    path: '/notifications',
    builder: (context, state) => const NotificationScreen(),
  ),
];
