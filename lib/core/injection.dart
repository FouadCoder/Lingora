import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lingora/core/service/audio_service.dart';
import 'package:lingora/core/usecases/play_audio_usecase.dart';
import 'package:lingora/features/analytics/data/datasources/analytics_remote_data.dart';
import 'package:lingora/features/analytics/data/repositories_impl/analytics_repository_impl.dart';
import 'package:lingora/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:lingora/features/analytics/domain/usecases/get_analytics_usecase.dart';
import 'package:lingora/features/analytics/domain/usecases/get_daily_activity_usercase.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:lingora/features/favorites/data/datasources/favorites_remote_data.dart';
import 'package:lingora/features/favorites/data/repositories_impl/favorites_repository_impl.dart';
import 'package:lingora/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:lingora/features/favorites/domain/usecases/add_to_favorites_usecase.dart';
import 'package:lingora/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:lingora/features/favorites/domain/usecases/remove_from_favorites_usecase.dart';
import 'package:lingora/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:lingora/features/history/data/datasources/history_remote_data.dart';
import 'package:lingora/features/history/data/repositories_impl/history_repository_impl.dart';
import 'package:lingora/features/history/domain/repositories/history_repository.dart';
import 'package:lingora/features/history/domain/usecases/fetch_history_usecase.dart';
import 'package:lingora/features/history/presentation/cubit/history_cubit.dart';
import 'package:lingora/features/words/data/datasources/library_local_data.dart';
import 'package:lingora/features/words/data/datasources/words_remote_data.dart';
import 'package:lingora/features/words/data/repositories_impl/library_repository_impl.dart';
import 'package:lingora/features/words/domain/repositories/library_repository.dart';
import 'package:lingora/features/words/domain/usecases/get_library_usecase.dart';
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
import 'package:lingora/features/translate/domain/usecases/translate_usecase.dart';
import 'package:lingora/features/translate/presentation/cubit/translate_cubit.dart';
import 'package:lingora/keys.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final injection = GetIt.instance;

Future<void> setupInjection() async {
  // Core
  await Supabase.initialize(url: supabaseURL, anonKey: supabaseAnonKey);
  injection.registerSingleton<SupabaseClient>(Supabase.instance.client);
  await Hive.initFlutter(); //  Hive database
  await Hive.openBox("db"); //  Hive database
  injection.registerSingleton(Hive);

  // Database
  injection.registerSingleton(TranslateRemoteData(injection()));
  injection.registerLazySingleton<WordsRemoteData>(
      () => WordsRemoteDataImpl(injection()));
  injection.registerSingleton(LibraryLocalData());
  injection.registerLazySingleton<AnalyticsRemoteData>(
      () => AnalyticsRemoteDataImpl(injection()));
  injection.registerSingleton(HistoryRemoteData(injection()));
  injection.registerSingleton(SettingsLocalData());
  injection.registerSingleton(FavoritesRemoteData(injection()));

  // Repositories
  injection.registerLazySingleton<TranslateRepository>(
      () => TranslateRepositoryImpl(injection()));
  injection.registerLazySingleton<LibraryRepository>(
      () => LibraryRepositoryImpl(injection(), injection()));
  injection.registerLazySingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(injection()));
  injection.registerLazySingleton<HistoryRepository>(
      () => HistoryRepositoryImpl(injection()));
  injection.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(injection()));
  injection.registerLazySingleton<FavoritesRepository>(
      () => FavoritesRepositoryImpl(injection()));

  // Services
  injection.registerLazySingleton(() => AudioService());

  //* Usecases

  // Translate
  injection.registerFactory(() => TranslateUsecase(injection()));
  // Library
  injection.registerFactory(() => GetLibraryUsecase(injection()));
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
  // Favorites
  injection.registerFactory(() => AddToFavoritesUsecase(injection()));
  injection.registerFactory(() => RemoveFromFavoritesUsecase(injection()));
  injection.registerFactory(() => GetFavoritesUsecase(injection()));

  // Cubit
  injection.registerFactory<TranslateCubit>(
      () => TranslateCubit(injection(), injection(), injection()));
  injection.registerFactory<LibraryCubit>(
      () => LibraryCubit(injection(), injection(), injection(), injection()));
  injection.registerFactory(() => NotesCubit(injection(), injection()));
  injection.registerFactory<AnalyticsCubit>(
      () => AnalyticsCubit(injection(), injection(), injection()));
  injection.registerFactory(() => HistoryCubit(injection(), injection()));
  injection.registerFactory(() => LanguageCubit(injection(), injection()));
  injection.registerFactory(() => ThemeCubit(injection(), injection()));
  injection.registerFactory(
      () => FavoritesCubit(injection(), injection(), injection(), injection()));
}
