import 'package:go_router/go_router.dart';
import 'package:lingora/pages/auth_gate.dart';
import 'package:lingora/pages/login.dart';
import 'package:lingora/pages/nav.dart';
import 'package:lingora/pages/onboarding/onboarding_screen.dart';
import 'package:lingora/pages/register.dart';

GoRouter router = GoRouter(initialLocation: '/onboarding', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => AuthGate(),
  ),
  GoRoute(path: '/nav', builder: (context, state) => Nav(), routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => Nav(
        indexPage: 0,
      ),
    ),
    GoRoute(
      path: '/translate',
      builder: (context, state) => Nav(
        indexPage: 1,
      ),
    ),
    GoRoute(
      path: '/library',
      builder: (context, state) => Nav(
        indexPage: 2,
      ),
    ),
    GoRoute(
      path: '/insights',
      builder: (context, state) => Nav(
        indexPage: 3,
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => Nav(
        indexPage: 4,
      ),
    ),
  ]),
  GoRoute(path: '/onboarding', builder: (context, state) => OnboardingScreen()),
  GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
  GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
]);
