import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lingora/core/service/audio_service.dart';
import 'package:lingora/core/service/launch_service.dart';
import 'package:lingora/core/service/notification_service.dart';
import 'package:lingora/core/usecases/play_audio_usecase.dart';
import 'package:lingora/features/translate/domain/usecases/translate_usecase.dart';
import 'package:lingora/features/analytics/data/datasources/analytics_remote_data.dart';
import 'package:lingora/features/analytics/data/repositories_impl/analytics_repository_impl.dart';
import 'package:lingora/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:lingora/features/analytics/domain/usecases/get_analytics_usecase.dart';
import 'package:lingora/features/analytics/domain/usecases/get_daily_activity_usercase.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:lingora/features/auth/data/datasources/auth_remote_data.dart';
import 'package:lingora/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lingora/features/notification/data/datasources/notification_remote_data.dart';
import 'package:lingora/features/notification/data/repositories_impl/notification_repository_impl.dart';
import 'package:lingora/features/notification/domain/repositories/notification_repository.dart';
import 'package:lingora/features/notification/domain/usecases/active_reminder_usecase.dart';
import 'package:lingora/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:lingora/features/notification/domain/usecases/get_reminders_usecase.dart';
import 'package:lingora/features/notification/domain/usecases/unactive_reminder_usecase.dart';
import 'package:lingora/features/notification/presentation/cubit/notifications/notification_cubit.dart';
import 'package:lingora/features/notification/presentation/cubit/reminders/reminder_cubit.dart';
import 'package:lingora/features/words/data/datasources/words_remote_data.dart';
import 'package:lingora/features/words/domain/usecases/favorites_usecase/add_to_favorites_usecase.dart';
import 'package:lingora/features/words/domain/usecases/favorites_usecase/get_favorites_usecase.dart';
import 'package:lingora/features/words/domain/usecases/favorites_usecase/remove_from_favorites_usecase.dart';
import 'package:lingora/features/words/domain/usecases/library_usecase/get_words_by_collection_usecase.dart';
import 'package:lingora/features/words/presentation/cubit/favorites/favorites_cubit.dart';
import 'package:lingora/features/history/data/datasources/history_remote_data.dart';
import 'package:lingora/features/history/data/repositories_impl/history_repository_impl.dart';
import 'package:lingora/features/history/domain/repositories/history_repository.dart';
import 'package:lingora/features/history/domain/usecases/fetch_history_usecase.dart';
import 'package:lingora/features/history/presentation/cubit/history_cubit.dart';
import 'package:lingora/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:lingora/features/auth/domain/usecases/login_usecase.dart';
import 'package:lingora/features/auth/domain/usecases/signup_usecase.dart';
import 'package:lingora/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lingora/features/auth/domain/usecases/check_session_usecase.dart';
import 'package:lingora/features/auth/domain/repositories/auth_repository.dart';
import 'package:lingora/features/words/data/repositories_impl/library_repository_impl.dart';
import 'package:lingora/features/words/domain/repositories/library_repository.dart';
import 'package:lingora/features/words/domain/usecases/library_usecase/get_library_usecase.dart';
import 'package:lingora/features/words/domain/usecases/notes_usecase/update_note_usecase.dart';
import 'package:lingora/features/words/domain/usecases/update_word_collection_usecase.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/notes/notes_cubit.dart';
import 'package:lingora/features/settings/data/datasources/settings_local_data.dart';
import 'package:lingora/features/settings/data/repositories_impl/settings_repository_impl.dart';
import 'package:lingora/features/settings/domain/repositories/settings_repository.dart';
import 'package:lingora/features/settings/domain/usecases/get_language_usecase.dart';
import 'package:lingora/features/settings/domain/usecases/get_theme_usecase.dart';
import 'package:lingora/features/settings/domain/usecases/save_language_usecase.dart';
import 'package:lingora/features/settings/domain/usecases/set_theme_usecase.dart';
import 'package:lingora/features/settings/presentation/cubit/language_cubit.dart';
import 'package:lingora/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:lingora/features/translate/data/datasources/translate_remote_data.dart';
import 'package:lingora/features/translate/data/repositories_impl/translate_repository_impl.dart';
import 'package:lingora/features/translate/domain/repositories/translate_repository.dart';
import 'package:lingora/features/translate/presentation/cubit/translate_cubit.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final injection = GetIt.instance;

Future<void> setupInjection() async {
  // Core
  await dotenv.load(fileName: ".env");

  // Supabase
  await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'), anonKey: dotenv.get('SUPABASE_ANONKEY'));
  injection.registerSingleton<SupabaseClient>(Supabase.instance.client);

  // Hive
  await Hive.initFlutter(); //  Hive database
  final box = await Hive.openBox("db"); //  Hive database
  injection.registerSingleton<Box>(box);

  // Notifications
  OneSignal.initialize(dotenv.get('ONESIGNAL_APP_ID'));

  // Database
  injection.registerSingleton(TranslateRemoteData(injection()));
  injection.registerLazySingleton<AnalyticsRemoteData>(
      () => AnalyticsRemoteDataImpl(injection()));
  injection.registerSingleton(HistoryRemoteData(injection()));
  injection.registerSingleton(SettingsLocalData());
  injection.registerLazySingleton<WordsRemoteData>(
      () => WordsRemoteDataImpl(injection()));
  injection.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(injection()));
  injection.registerLazySingleton<AuthRemoteData>(
      () => AuthRemoteDataImpl(injection()));

  // Repositories
  injection.registerLazySingleton<TranslateRepository>(
      () => TranslateRepositoryImpl(injection()));
  injection.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(injection()));
  injection.registerLazySingleton<LibraryRepository>(
      () => LibraryRepositoryImpl(injection()));
  injection.registerLazySingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(injection()));
  injection.registerLazySingleton<HistoryRepository>(
      () => HistoryRepositoryImpl(injection()));
  injection.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(injection()));
  injection.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoriesImpl(injection()));

  //* Services
  injection.registerLazySingleton(() => AudioService());
  injection.registerLazySingleton(
      () => NotificationService(injection(), injection()));
  injection
      .registerLazySingleton(() => LaunchService(injection(), injection()));

  //* Usecases

  // Auth
  injection.registerFactory(() => LoginUseCase(injection()));
  injection.registerFactory(() => SignUpUseCase(injection()));
  injection.registerFactory(() => LogoutUseCase(injection()));
  injection.registerFactory(() => CheckSessionUseCase(injection()));
  // Library
  injection.registerFactory(() => GetLibraryUsecase(injection()));
  injection.registerFactory(() => GetWordsByCollectionUsecase(injection()));
  injection.registerFactory(() => UpdateWordCollectionUsecase(injection()));
  // Analytics
  injection.registerFactory(() => GetAnalyticsUsecase(injection()));
  injection.registerFactory(() => GetDailyActivityUsercase(injection()));
  // History
  injection.registerFactory(() => FetchHistoryUseCase(injection()));
  // Setting
  injection.registerFactory(() => SaveLanguageUsecase(injection()));
  injection.registerFactory(() => GetLanguageUsecase(injection()));
  injection.registerFactory(() => SetThemeUsecase(injection()));
  injection.registerFactory(() => GetThemeUsecase(injection()));
  // Notes
  injection.registerFactory(() => UpdateNoteUsecase(injection()));
  // Audio
  injection.registerFactory(() => PlayAudioUsecase(injection()));
  // Translate
  injection.registerFactory(() => TranslateUsecase(injection()));
  // Favorites
  injection.registerFactory(() => AddToFavoritesUsecase(injection()));
  injection.registerFactory(() => RemoveFromFavoritesUsecase(injection()));
  injection.registerFactory(() => GetFavoritesUsecase(injection()));
  // Notification
  injection.registerFactory(() => GetNotificationsUseCase(injection()));
  // Reminders
  injection.registerFactory(() => GetRemindersUseCase(injection()));
  injection.registerFactory(() => ActiveReminderUseCase(injection()));
  injection.registerFactory(() => UnactiveReminderUseCase(injection()));

  // Cubit
  injection.registerFactory<TranslateCubit>(
      () => TranslateCubit(injection(), injection(), injection()));
  injection.registerFactory<LibraryCubit>(() => LibraryCubit(
      injection(), injection(), injection(), injection(), injection()));
  injection.registerFactory(() => NotesCubit(injection(), injection()));
  injection.registerFactory<AuthCubit>(() => AuthCubit(
        injection(),
        injection(),
        injection(),
        injection(),
        injection(),
      ));
  injection.registerFactory<AnalyticsCubit>(
      () => AnalyticsCubit(injection(), injection(), injection()));
  injection.registerFactory(() => HistoryCubit(injection(), injection()));
  injection.registerFactory(() => LanguageCubit(injection(), injection()));
  injection.registerFactory(() => ThemeCubit(injection(), injection()));
  injection.registerFactory(
      () => FavoritesCubit(injection(), injection(), injection(), injection()));
  injection.registerFactory(() => NotificationCubit(injection()));
  injection.registerFactory(
      () => ReminderCubit(injection(), injection(), injection()));
}
