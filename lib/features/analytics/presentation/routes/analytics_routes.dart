import 'package:go_router/go_router.dart';
import 'package:lingora/features/analytics/domain/entities/daily_activity_entity.dart';
import 'package:lingora/features/analytics/presentation/pages/insights_months_view.dart';
import 'package:lingora/features/analytics/presentation/pages/insights_screen.dart';

final analyticsRoutes = [
  GoRoute(
    path: '/analysis',
    builder: (context, state) => const InsightsScreen(),
  ),
  GoRoute(
    path: '/analysis/details',
    builder: (context, state) => InsightsDetailsScreen(
        entries:
            state.extra as Map<int, Map<String, List<DailyActivityEntity>>>?),
  ),
];
