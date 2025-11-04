import 'package:go_router/go_router.dart';
import 'package:lingora/features/translate/presentation/pages/translate_screen.dart';

final translateRoutes = [
  GoRoute(
      path: '/translate', builder: (context, state) => const TranslateScreen())
];
