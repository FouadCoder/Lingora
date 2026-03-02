import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/service/launch_service.dart';
import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/settings/domain/usecases/get_language_usecase.dart';
import 'package:lingora/features/settings/domain/usecases/save_language_usecase.dart';
import 'package:lingora/features/settings/domain/usecases/get_system_language_usecase.dart';
import 'package:lingora/features/settings/presentation/cubit/language/language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final GetLanguageUsecase getLanguageUsecase;
  final SaveLanguageUsecase saveLanguageUsecase;
  final GetSystemLanguageUsecase getSystemLanguageUsecase;
  final LaunchService launchService;

  LanguageCubit(
    this.getLanguageUsecase,
    this.saveLanguageUsecase,
    this.getSystemLanguageUsecase,
    this.launchService,
  ) : super(LanguageState());

  // Set Language
  Future<void> setLanguage(Language language) async {
    try {
      emit(state.copyWith(status: LanguageStatus.loading));
      await saveLanguageUsecase.call(language);

      emit(state.copyWith(status: LanguageStatus.success, language: language));
    } catch (e) {
      emit(state.copyWith(status: LanguageStatus.error));
    }
  }

  // Get language
  void getLanguage() async {
    try {
      emit(state.copyWith(status: LanguageStatus.loading));
      final appOpenCount = await launchService.getAppOpenCount();
      // First open
      if (appOpenCount == 1) {
        final systemLanguage = await getLanguageUsecase.call();
        await setLanguage(systemLanguage!);
        emit(state.copyWith(
            status: LanguageStatus.success, language: systemLanguage));
      } else {
        final lang = await getLanguageUsecase.call();
        emit(state.copyWith(status: LanguageStatus.success, language: lang));
      }
    } catch (e) {
      emit(state.copyWith(status: LanguageStatus.error));
    }
  }
}
