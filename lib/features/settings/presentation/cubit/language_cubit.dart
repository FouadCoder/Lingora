import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/settings/domain/usecases/get_language_usecase.dart';
import 'package:lingora/features/settings/domain/usecases/save_language_usecase.dart';
import 'package:lingora/features/settings/presentation/cubit/language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final GetLanguageUsecase getLanguageUsecase;
  final SaveLanguageUsecase saveLanguageUsecase;

  LanguageCubit({
    required this.getLanguageUsecase,
    required this.saveLanguageUsecase,
  }) : super(LanguageState());

  // Get language
  void getLanguage() async {
    try {
      emit(state.copyWith(status: LanguageStatus.loading));
      final lang = await getLanguageUsecase.call();

      print("Lan ========= ${lang!.name}");

      emit(state.copyWith(status: LanguageStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LanguageStatus.error));
    }
  }

  // Set Language
  void setLanguage(Language language) async {
    try {
      emit(state.copyWith(status: LanguageStatus.loading));
      await saveLanguageUsecase.call(language);

      emit(state.copyWith(status: LanguageStatus.success));
    } catch (e) {
      emit(state.copyWith(status: LanguageStatus.error));
    }
  }
}
