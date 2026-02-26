import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/config/theme/light_theme.dart';
import 'package:lingora/core/injection.dart';
import 'package:lingora/core/service/launch_service.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:lingora/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lingora/features/notification/presentation/cubit/notifications/notification_cubit.dart';
import 'package:lingora/features/notification/presentation/cubit/reminders/reminder_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/favorites/favorites_cubit.dart';
import 'package:lingora/features/history/presentation/cubit/history_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/notes/notes_cubit.dart';
import 'package:lingora/features/settings/presentation/cubit/language/language_cubit.dart';
import 'package:lingora/features/settings/presentation/cubit/language/language_state.dart';
import 'package:lingora/features/settings/presentation/cubit/theme/theme_cubit.dart';
import 'package:lingora/features/settings/presentation/cubit/theme/theme_state.dart';
import 'package:lingora/features/translate/presentation/cubit/translate_cubit.dart';
import 'package:lingora/config/router/routes.dart';
import 'package:lingora/config/theme/dark_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupInjection();

  final launchService = injection<LaunchService>();
  await launchService.launch();

  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en'),
      Locale('ar'),
    ],
    path: 'assets/translations',
    fallbackLocale: Locale("en"),
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
              create: (context) => injection<TranslateCubit>()), // Translate
          BlocProvider<LibraryCubit>(
              create: (context) => injection<LibraryCubit>()), // Library
          BlocProvider<NotesCubit>(
              create: (context) => injection<NotesCubit>()), // Notes
          BlocProvider<AnalyticsCubit>(
              create: (context) =>
                  injection<AnalyticsCubit>()), // User Analytics
          BlocProvider<HistoryCubit>(
              create: (context) => injection<HistoryCubit>()), // History
          BlocProvider<LanguageCubit>(
              create: (context) => injection<LanguageCubit>()), // Language
          BlocProvider<ThemeCubit>(
              create: (context) =>
                  injection<ThemeCubit>()..getTheme()), // Theme
          BlocProvider<FavoritesCubit>(
              create: (context) => injection<FavoritesCubit>()), // Favorites
          BlocProvider<NotificationCubit>(
              create: (context) =>
                  injection<NotificationCubit>()), // Notification
          BlocProvider<ReminderCubit>(
              create: (context) => injection<ReminderCubit>()), // Reminder
          BlocProvider<AuthCubit>(
            create: (context) => injection<AuthCubit>()..checkSession(),
            lazy: false,
          ), // Auth

          //TODO adjust the cubits below
          BlocProvider<LevelCubit>(create: (context) => LevelCubit()), // Level
        ],
        child: BlocListener<LanguageCubit, LanguageState>(
          listener: (context, state) {
            if (state.status == LanguageStatus.success &&
                state.language != null) {
              context.setLocale(Locale(state.language!.code));
            }
          },
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp.router(
                theme: state == ThemeState.dark ? darkTheme : lightTheme,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                routerConfig: router,
              );
            },
          ),
        ));
  }
}
