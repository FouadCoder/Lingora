import 'package:go_router/go_router.dart';
import 'package:lingora/features/library/presentation/pages/library_screen.dart';

final libraryRoutes = [
  GoRoute(
    path: '/library',
    builder: (context, state) => LibraryScreen(),
  )
];
