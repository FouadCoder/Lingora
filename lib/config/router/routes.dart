import 'package:go_router/go_router.dart';
import 'package:lingora/features/library/presentation/routes/library_routes.dart';
import 'package:lingora/features/translate/presentation/routes/translate_routes.dart';
import 'package:lingora/models/translate.dart';
import 'package:lingora/pages/auth_screen/auth_gate.dart';
import 'package:lingora/pages/auth_screen/login.dart';
import 'package:lingora/pages/auth_screen/signup_success.dart';
import 'package:lingora/pages/favorites_screen/favorites.dart';
import 'package:lingora/pages/history/history.dart';
import 'package:lingora/pages/insights/insights_details.dart';
import 'package:lingora/pages/nav.dart';
import 'package:lingora/pages/onboarding/onboarding_screen.dart';
import 'package:lingora/pages/auth_screen/register.dart';
import 'package:lingora/pages/word_details/word_details_screen.dart';

GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => AuthGate(),
  ),
  GoRoute(path: '/nav', builder: (context, state) => Nav(), routes: [
    GoRoute(
        path: 'home',
        builder: (context, state) => Nav(
              indexPage: 0,
            ),
        routes: [
          GoRoute(path: 'history', builder: (context, state) => History()),
          GoRoute(
            path: 'favorites',
            builder: (context, state) => FavoritesScreen(),
          ),
        ]),
    GoRoute(
      path: 'translate',
      builder: (context, state) => Nav(
        indexPage: 1,
      ),
    ),
    GoRoute(
        path: 'library',
        builder: (context, state) => Nav(
              indexPage: 2,
            ),
        routes: [
          GoRoute(
              path: 'word_details',
              builder: (context, state) =>
                  WordDetailsScreen(model: state.extra as Translate))
        ]),
    GoRoute(
      path: 'insights',
      builder: (context, state) => Nav(
        indexPage: 3,
      ),
      routes: [
        GoRoute(
            path: 'details',
            builder: (context, state) => InsightsDetailsScreen())
      ],
    ),
    GoRoute(
      path: 'setting',
      builder: (context, state) => Nav(
        indexPage: 4,
      ),
    ),
  ]),
  GoRoute(path: '/onboarding', builder: (context, state) => OnboardingScreen()),
  GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
  GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
  GoRoute(
      path: '/signup_success',
      builder: (context, state) => SignupSuccessScreen()),
]);

//! This is the new router
GoRouter goRouterNew = GoRouter(
    initialLocation: '/', routes: [...translateRoutes, ...libraryRoutes]);
