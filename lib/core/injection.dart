import 'package:get_it/get_it.dart';
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
  injection.registerSingleton(TranslateRemoteData());

  // Repositories
  injection.registerLazySingleton<TranslateRepository>(
      () => TranslateRepositoryImpl(injection()));

  // Usecases
  injection.registerFactory(() => TranslateUsecase(injection()));

  // Cubit
  injection.registerFactory<TranslateCubit>(() => TranslateCubit(injection()));
}
