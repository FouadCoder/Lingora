import 'dart:convert';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/keys.dart';
import 'package:lingora/models/translate.dart';

class TranslateCubit extends Cubit<TranslateState> {
  TranslateCubit() : super(const TranslateState());

  // Gemini Ai Model
  final modelGemini =
      GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKeygeminiModel);

  // Update input text
  void updateInput(String text) {
    emit(state.copyWith(
      inputText: text,
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
    Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));
    final url = 'https://api-inference.huggingface.co/models/$model-$from-$to';

    // Send request
    final response = await dio
        .post(
          url,
          data: {"inputs": state.inputText.trim()},
          options: Options(
            headers: {
              "Authorization": "Bearer $apiHuggingFace",
              "Content-Type": "application/json",
            },
          ),
        )
        .timeout(const Duration(seconds: 30));

    // Res
    final data = response.data;
    String translated = '';
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
- Include pos (part of speech) and pronunciation as top-level fields
- meaning: short definition in "$to"
- examples: 2–3 sentences in "$to" (plain text only, no language codes)
- synonyms: list in "$from"

Reply ONLY with valid JSON in this format:
{
  "pos": "...",           // e.g., "noun", "verb"
  "pronunciation": "...", // e.g., "/nɪs/"
  "meaning": "...",
  "examples": ["...", "..."],
  "synonyms": ["...", "..."]
}
''';

    final res = await modelGemini.generateContent(
        [Content.text(prompt)]).timeout(const Duration(seconds: 30));

    // Raw text
    final raw = res.text ?? '';
    // If it's JSON, parse it
    final cleaned = raw.replaceAll(RegExp(r'```(json)?|```'), '').trim();

    final data = jsonDecode(cleaned) as Map<String, dynamic>;

    // Clean trailing dots from examples
    if (data['examples'] is List) {
      data['examples'] = (data['examples'] as List)
          .map((e) => e is String ? e.replaceAll(RegExp(r'\.$'), '') : e)
          .toList();
    }

    return data;
  }

  //translation
  Future<void> translate() async {
    try {
      if (state.inputText.trim().isEmpty) {
        emit(state.copyWith(status: TranslateStatus.empty));
        return;
      }
      emit(state.copyWith(status: TranslateStatus.loading));
      print("Start loading =====================================");

      final from = (state.sourceLanguage.code);
      final to = (state.targetLanguage.code);
      String translated = await fetchTranslateWords(from, to);
      final detailsWord = await fetchWordsDetails(from, to);
      final data = {
        "original": state.inputText.trim(),
        "translated": translated,
        "meaning": detailsWord["meaning"],
        "examples": detailsWord["examples"],
        "synonyms": detailsWord["synonyms"],
        "pos": detailsWord["pos"],
        "pronunciation": detailsWord["pronunciation"],
        "translateFrom": state.sourceLanguage,
        "translateTo": state.targetLanguage,
      };
      Translate translate = Translate.fromJson(data);

      print("Translated =================");
      print("Original: ${translate.original}");
      print("Translated: ${translate.translated}");
      print("POS: ${translate.pos}");
      print("Pronunciation: ${translate.pronunciation}");
      print("Meaning: ${translate.meaning}");
      print("Examples: ${translate.examples}");
      print("Synonyms: ${translate.synonyms}");
      print("From: ${translate.translateFrom.code}");
      print("To: ${translate.translateTo.code}");
      emit(state.copyWith(status: TranslateStatus.success, result: translate));
    } catch (e) {
      print("Error ============================= $e");
      emit(state.copyWith(status: TranslateStatus.failure));
    }
  }

  // Clear the current translation result
  void clearResult() {
    emit(state.copyWith(result: null, status: TranslateStatus.initial));
  }
}
