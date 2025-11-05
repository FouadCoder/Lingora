import 'package:go_router/go_router.dart';
import 'package:lingora/features/library/domain/entities/word_entity.dart';
import 'package:lingora/features/library/presentation/pages/library_screen.dart';
import 'package:lingora/features/library/presentation/pages/word_details_screen.dart';

final libraryRoutes = [
  GoRoute(
    path: '/library',
    builder: (context, state) => LibraryScreen(),
  ),
  GoRoute(
      path: '/library/:id',
      builder: (context, state) =>
          WordDetailsScreen(model: state.extra as WordEntity))
];
