import 'package:get_it/get_it.dart';
import 'package:lingora/features/analytics/data/datasources/analytics_remote_data.dart';
import 'package:lingora/features/analytics/data/repositories_impl/analytics_repository_impl.dart';
import 'package:lingora/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:lingora/features/analytics/domain/usecases/get_analytics_usecase.dart';
import 'package:lingora/features/analytics/domain/usecases/get_daily_activity_usercase.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:lingora/features/library/data/datasources/library_remote_data.dart';
import 'package:lingora/features/library/data/repositories_impl/library_repository_impl.dart';
import 'package:lingora/features/library/domain/repositories/library_repository.dart';
import 'package:lingora/features/library/domain/usecases/get_library_usecase.dart';
import 'package:lingora/features/library/presentation/cubit/library_cubit.dart';
import 'package:lingora/features/notes/data/datasources/notes_remote_data.dart';
import 'package:lingora/features/notes/data/repositories_impl/notes_repository_impl.dart';
import 'package:lingora/features/notes/domain/repositories/notes_repository.dart';
import 'package:lingora/features/notes/domain/usecases/update_note_usecase.dart';
import 'package:lingora/features/notes/presentation/cubit/notes_cubit.dart';
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

  // Database
  injection.registerSingleton(TranslateRemoteData(injection()));
  injection.registerSingleton(LibraryRemoteData(injection()));
  injection.registerSingleton(NotesRemoteData(injection()));
  injection.registerSingleton(AnalyticsRemoteData(injection()));

  // Repositories
  injection.registerLazySingleton<TranslateRepository>(
      () => TranslateRepositoryImpl(injection()));
  injection.registerLazySingleton<LibraryRepository>(
      () => LibraryRepositoryImpl(injection()));
  injection.registerLazySingleton<NotesRepository>(
      () => NotesRepositoryImpl(injection()));
  injection.registerLazySingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(injection()));

  //* Usecases

  // Translate
  injection.registerFactory(() => TranslateUsecase(injection()));
  // Library
  injection.registerFactory(() => GetLibraryUsecase(injection()));
  // Notes
  injection.registerFactory(() => UpdateNoteUsecase(injection()));
  // Analytics
  injection.registerFactory(() => GetAnalyticsUsecase(injection()));
  injection.registerFactory(() => GetDailyActivityUsercase(injection()));

  // Cubit
  injection.registerFactory<TranslateCubit>(
      () => TranslateCubit(injection(), injection()));
  injection.registerFactory<LibraryCubit>(
      () => LibraryCubit(injection(), injection()));
  injection.registerFactory(() => NotesCubit(injection(), injection()));
  injection.registerFactory<AnalyticsCubit>(
      () => AnalyticsCubit(injection(), injection(), injection()));
}
