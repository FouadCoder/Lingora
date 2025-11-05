import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lingora/core/injection.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/features/library/presentation/cubit/library_cubit.dart';
import 'package:lingora/features/translate/presentation/cubit/translate_cubit.dart';
import 'package:lingora/config/router/routes.dart';
import 'package:lingora/config/theme/dark_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupInjection();
  await Hive.initFlutter(); //  Hive database
  await Hive.openBox("db"); //  Hive database
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en'),
    ],
    path: 'assets/translations',
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<TranslateCubit>(
              create: (context) =>
                  injection<TranslateCubit>()), // Get Translated words
          BlocProvider<LibraryCubit>(
              create: (context) => injection<LibraryCubit>()), // Library
          BlocProvider<AuthAppCubit>(
            create: (context) => AuthAppCubit()..launch(),
            lazy: false,
          ), // Auth
          BlocProvider<HistoryCubit>(
              create: (context) => HistoryCubit()), // History
          BlocProvider<FavoritesCubit>(
              create: (context) => FavoritesCubit()), // Favorites
          BlocProvider<LevelCubit>(create: (context) => LevelCubit()), // Level
          BlocProvider<AnalyticsCubit>(
              create: (context) => AnalyticsCubit()), // User Analytics
          BlocProvider<CategoryCubit>(
              create: (context) => CategoryCubit()), // Category
        ],
        child: MaterialApp.router(
          theme: darkTheme,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: router,
        ));
  }
}
