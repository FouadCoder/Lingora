import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/keys.dart';
import 'package:lingora/data/langauges_list.dart';

class TranslateCubit extends Cubit<TranslateState> {
  TranslateCubit() : super(const TranslateState());

  // Update input text
  void updateInput(String text) {
    emit(state.copyWith(
      inputText: text,
      status: TranslateStatus.initial,
    ));
  }

  // Update selected languages
  void updateLanguages({Language? from, Language? to}) {
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

  //translation
  Future<void> translate() async {
    emit(state.copyWith(status: TranslateStatus.loading));

    try {
      Dio dio = Dio();

      if (state.inputText.trim().isEmpty) {
        emit(state.copyWith(status: TranslateStatus.empty));
        return;
      }

      final from = (state.sourceLanguage.code);
      final to = (state.targetLanguage.code);
      print("To language =========== ${state.targetLanguage.name}");

      print(
          "Input === ${state.inputText} ========= FROM $from  ========== To $to");
      final url =
          'https://api-inference.huggingface.co/models/$model-$from-$to';

      final response = await dio.post(
        url,
        data: {"inputs": state.inputText.trim()},
        options: Options(
          headers: {
            "Authorization": "Bearer $apiHuggingFace",
            "Content-Type": "application/json",
          },
        ),
      );

      final data = response.data;
      String translated = state.translatedText;
      if (data is List &&
          data.isNotEmpty &&
          data[0] is Map &&
          data[0]['translation_text'] is String) {
        translated = data[0]['translation_text'] as String;
      }

      print(
          "======================================================== $translated");

      emit(state.copyWith(
          status: TranslateStatus.success, translatedText: translated));
    } catch (e) {
      emit(state.copyWith(status: TranslateStatus.failure));
    }
  }

  // Clear the current translation result
  void clearResult() {
    emit(state.copyWith(translatedText: '', status: TranslateStatus.initial));
  }
}
