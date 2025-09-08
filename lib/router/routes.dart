import 'package:go_router/go_router.dart';
import 'package:lingora/pages/home.dart';
import 'package:lingora/pages/nav.dart';
import 'package:lingora/pages/translate/translate_screen.dart';

GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => Nav(),
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => HomeScreen(),
  ),
  GoRoute(
    path: '/translate',
    builder: (context, state) => TranslateScreen(),
  )
]);
