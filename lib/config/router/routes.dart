import 'package:go_router/go_router.dart';
import 'package:lingora/features/analytics/presentation/routes/analytics_routes.dart';
import 'package:lingora/features/auth/presentation/routes/auth_routes.dart';
import 'package:lingora/features/history/presentation/routes/history_routes.dart';
import 'package:lingora/features/home/presentation/routes/home_routes.dart';
import 'package:lingora/features/library/presentation/routes/library_routes.dart';
import 'package:lingora/features/translate/presentation/routes/translate_routes.dart';

GoRouter router = GoRouter(initialLocation: '/', routes: [
  ...translateRoutes,
  ...libraryRoutes,
  ...analyticsRoutes,
  ...authRoutes,
  ...historyRoutes,
  ...homeRoutes
]);
