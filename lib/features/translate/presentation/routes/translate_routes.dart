import 'package:go_router/go_router.dart';
import 'package:lingora/nav.dart';

final translateRoutes = [
  GoRoute(
      path: '/translate',
      builder: (context, state) => Nav(
            isFullScreen: true,
          ))
];
