import 'package:go_router/go_router.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/domain/enums/collection_enum.dart';
import 'package:lingora/features/words/presentation/pages/favorites/favorites_screen.dart';
import 'package:lingora/features/words/presentation/pages/library/collection_words_screen.dart';
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
  GoRoute(
    path: '/collections/:collectionType',
    builder: (context, state) {
      final collectionType = state.pathParameters['collectionType'];
      final type = CollectionType.values.firstWhere(
        (e) => e.name == collectionType,
        orElse: () => CollectionType.learning,
      );
      return CollectionWordsScreen(collectionType: type);
    },
  )
];

final favoritesRoutes = [
  GoRoute(
    path: '/favorites',
    builder: (context, state) => FavoritesScreen(),
  ),
];
