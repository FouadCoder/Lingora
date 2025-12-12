import 'package:go_router/go_router.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/presentation/pages/favorites/favorites_screen.dart';
import 'package:lingora/features/words/presentation/pages/library/library_screen.dart';
import 'package:lingora/features/words/presentation/pages/library/word_details_screen.dart';

final libraryRoutes = [
  GoRoute(
    path: '/library',
    builder: (context, state) => LibraryScreen(),
  ),
  GoRoute(
      path: '/library/:id',
      builder: (context, state) {
        final extra = state.extra as WordEntity;
        return WordDetailsScreen(model: extra);
      }),
];

final favoritesRoutes = [
  GoRoute(
    path: '/favorites',
    builder: (context, state) => FavoritesScreen(),
  )
];
