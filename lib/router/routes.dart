import 'package:go_router/go_router.dart';
import 'package:lingora/pages/home.dart';
import 'package:lingora/pages/nav.dart';
import 'package:lingora/pages/translate_screen/translate_screen.dart';
import 'package:lingora/pages/word_details/word_details_screen.dart';

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
  ),
  GoRoute(
    path: '/word_details',
    builder: (context, state) => WordDetailsScreen(),
  )
]);
