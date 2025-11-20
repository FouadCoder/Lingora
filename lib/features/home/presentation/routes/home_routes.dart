import 'package:go_router/go_router.dart';

import 'package:lingora/pages/nav.dart';

final homeRoutes = [
  GoRoute(
    path: "/home",
    builder: (context, state) => Nav(
      indexPage: 0,
    ),
  )
];
