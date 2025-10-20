import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/keys.dart';
import 'package:lingora/router/routes.dart';
import 'package:lingora/theme/dark_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Supabase.initialize(url: supabaseURL, anonKey: supabaseAnonKey);
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
              create: (context) => TranslateCubit()), // Translate
          BlocProvider<FetchTranslatedLibraryCubit>(
              create: (context) =>
                  FetchTranslatedLibraryCubit()), // Get Translated words
          BlocProvider<AuthAppCubit>(
            create: (context) => AuthAppCubit()..launch(),
            lazy: false,
          ), // Auth
          BlocProvider<HistoryCubit>(
              create: (context) => HistoryCubit()), // History
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
