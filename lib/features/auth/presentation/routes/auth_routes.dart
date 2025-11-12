import 'package:go_router/go_router.dart';
import 'package:lingora/pages/auth_screen/auth_gate.dart';
import 'package:lingora/pages/auth_screen/login.dart';
import 'package:lingora/pages/auth_screen/register.dart';
import 'package:lingora/pages/auth_screen/signup_success.dart';
import 'package:lingora/pages/onboarding/onboarding_screen.dart';

final authRoutes = [
  GoRoute(path: '/', builder: (context, state) => const AuthGate()),
  GoRoute(path: '/onboarding', builder: (context, state) => OnboardingScreen()),
  GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
  GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
  GoRoute(
      path: '/signup_success',
      builder: (context, state) => SignupSuccessScreen()),
];
