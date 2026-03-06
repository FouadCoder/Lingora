import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/exceptions/network_exception.dart';
import 'package:lingora/core/usecases/play_audio_usecase.dart';
import 'package:lingora/features/translate/domain/usecases/translate_params.dart';
import 'package:lingora/features/translate/domain/usecases/translate_usecase.dart';
import 'package:lingora/features/translate/presentation/cubit/translate_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TranslateCubit extends Cubit<TranslateState> {
  final TranslateUsecase translateUsecase;
  final PlayAudioUsecase playAudioUsecase;
  final SupabaseClient supabaseClient;
  TranslateCubit(
      this.translateUsecase, this.supabaseClient, this.playAudioUsecase)
      : super(const TranslateState());

  // Update input text
  void updateInput(String text) {
    emit(state.copyWith(inputText: text, status: TranslateStatus.initial));
  }

  // Update selected languages
  void updateLanguages({from, to}) {
    emit(state.copyWith(
      sourceLanguage: from ?? state.sourceLanguage,
      targetLanguage: to ?? state.targetLanguage,
    ));
  }

  // Swap languages
  void swapLanguages() {
    emit(state.copyWith(
      sourceLanguage: state.targetLanguage,
      targetLanguage: state.sourceLanguage,
    ));
  }

  // Clear the current translation result
  void clearResult() {
    emit(state.copyWith(result: null, status: TranslateStatus.initial));
  }

  Future<void> translate() async {
    try {
      // If input is empty
      if (state.inputText.trim().isEmpty) {
        emit(state.copyWith(status: TranslateStatus.empty));
        return;
      }

      emit(state.copyWith(status: TranslateStatus.loading));

      // Create params
      final params = TranslateParams(
        input: state.inputText,
        from: state.sourceLanguage.code,
        to: state.targetLanguage.code,
      );

      // Translate
      final translate = await translateUsecase.call(params);
      emit(state.copyWith(status: TranslateStatus.success, result: translate));
    } on NetworkException {
      emit(state.copyWith(status: TranslateStatus.networkError));
    } catch (e) {
      emit(state.copyWith(status: TranslateStatus.failure));
    }
  }

  // Play Audio
  void playAudio(String word, String lang) async {
    try {
      await playAudioUsecase.call(word, lang: lang);
    } catch (_) {}
  }

  // Reset cubit state (for logout)
  void reset() {
    emit(const TranslateState());
  }
}
