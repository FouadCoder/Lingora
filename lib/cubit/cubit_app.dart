import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/keys.dart';

class TranslateCubit extends Cubit<TranslateState> {
  TranslateCubit() : super(const TranslateState());

  // Gemini Ai Model
  final modelGemini =
      GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKeygeminiModel);

  // Update input text
  void updateInput(String text) {
    emit(state.copyWith(
      inputText: text,
      status: TranslateStatus.initial,
    ));
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

  // translate Text from Hugging Face model
  Future<String> fetchTranslateWords(String from, String to) async {
    print("To ========== $to From ========= $from");
    Dio dio = Dio();
    final url = 'https://api-inference.huggingface.co/models/$model-$from-$to';

    // Send request
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

    // Res
    final data = response.data;
    String translated = state.translatedText;
    if (data is List &&
        data.isNotEmpty &&
        data[0] is Map &&
        data[0]['translation_text'] is String) {
      translated = data[0]['translation_text'] as String;
    }
    return translated;
  }

  // Get meaning , examples , Synonyms
  Future fetchWordsDetails(String from, String to) async {
    final prompt = '''
Act as a dictionary. Explain "${state.inputText.trim()}".
- meaning: short definition in "$to"
- examples: 2–3 sentences in "$to"
- synonyms: list in "$from"

Reply ONLY with valid JSON:
{ "meaning": ..., "examples": [...], "synonyms": [...] }
''';

    final res = await modelGemini.generateContent([Content.text(prompt)]);

    // Raw text
    final raw = res.text ?? '';
    // print('rse Ai Gemini ========================= $raw');

    // If it's JSON, parse it
    final cleaned = raw.replaceAll(RegExp(r'```(json)?|```'), '').trim();

    final data = jsonDecode(cleaned) as Map<String, dynamic>;
    print('meaning: ${data['meaning']}');
    print('examples: ${data['examples']}');
    print('synonyms: ${data['synonyms']}');
    return data;
  }

  //translation
  Future<void> translate() async {
    emit(state.copyWith(status: TranslateStatus.loading));

    try {
      if (state.inputText.trim().isEmpty) {
        emit(state.copyWith(status: TranslateStatus.empty));
        return;
      }

      final from = (state.sourceLanguage.code);
      final to = (state.targetLanguage.code);

      String translated = await fetchTranslateWords(from, to);

      print(
          "Transalted ======================================================== $translated");
      await fetchWordsDetails(from, to);

      emit(state.copyWith(
          status: TranslateStatus.success, translatedText: translated));
    } catch (e) {
      print("Error ============================= $e");
      emit(state.copyWith(status: TranslateStatus.failure));
    }
  }

  // Clear the current translation result
  void clearResult() {
    emit(state.copyWith(translatedText: '', status: TranslateStatus.initial));
  }
}
