import 'package:go_router/go_router.dart';
import 'package:lingora/pages/home.dart';
import 'package:lingora/pages/translate.dart';

GoRouter router = GoRouter(initialLocation: '/home', routes: [
  GoRoute(
    path: '/home',
    builder: (context, state) => HomeScreen(),
  ),
  GoRoute(
    path: '/translate',
    builder: (context, state) => TranslateScreen(),
  )
]);
