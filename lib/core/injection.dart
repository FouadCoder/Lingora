import 'package:get_it/get_it.dart';
import 'package:lingora/features/library/data/datasources/library_remote_data.dart';
import 'package:lingora/features/library/data/repositories_impl/library_repository_impl.dart';
import 'package:lingora/features/library/domain/repositories/library_repository.dart';
import 'package:lingora/features/library/domain/usecases/get_library_usecase.dart';
import 'package:lingora/features/library/presentation/cubit/library_cubit.dart';
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

  // Repositories
  injection.registerLazySingleton<TranslateRepository>(
      () => TranslateRepositoryImpl(injection()));
  injection.registerLazySingleton<LibraryRepository>(
      () => LibraryRepositoryImpl(injection()));

  //* Usecases

  // Translate
  injection.registerFactory(() => TranslateUsecase(injection()));
  // Library
  injection.registerFactory(() => GetLibraryUsecase(injection()));

  // Cubit
  injection.registerFactory<TranslateCubit>(
      () => TranslateCubit(injection(), injection()));
  injection.registerFactory<LibraryCubit>(
      () => LibraryCubit(injection(), injection()));
}
