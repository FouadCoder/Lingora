import 'package:go_router/go_router.dart';
import 'package:lingora/features/history/presentation/pages/history_screen.dart';

final historyRoutes = [
  GoRoute(
    path: '/history',
    builder: (context, state) => HistoryScreen(),
  )
];
