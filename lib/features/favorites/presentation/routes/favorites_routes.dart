import 'package:go_router/go_router.dart';
import 'package:lingora/features/favorites/presentation/pages/favorites_screen.dart';

final favoritesRoutes = [
  GoRoute(
    path: '/favorites',
    builder: (context, state) => FavoritesScreen(),
  )
];
