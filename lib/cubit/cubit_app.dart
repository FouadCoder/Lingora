import 'dart:convert';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/keys.dart';
import 'package:lingora/models/translate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Translate
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

- "original": corrected version of the input (fix casing, typos, etc.)
- pos (part of speech) and pronunciation as top-level fields
- meaning: short definition in "$to"
- examples: 2–3 sentences in "$to" (plain text only, no language codes)
- synonyms: list in "$from"

Reply ONLY with valid JSON in this format:
{
  "original": "...",        // corrected form of the input
  "pos": "...",             // e.g., "noun", "verb"
  "pronunciation": "...",   // e.g., "/nɪs/"
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

  // Save in server
  Future saveWord(Translate translate) async {
    Map word = {
      "user_id": translate.userId,
      "category_id": translate.categoryId,
      "original": translate.original,
      "translated": translate.translated,
      "pos": translate.pos,
      "pronunciation": translate.pronunciation,
      "meaning": translate.meaning,
      "examples": translate.examples,
      "synonyms": translate.synonyms,
      "translate_from": translate.translateFrom?.code,
      "translate_to": translate.translateTo?.code,
      "created_at": translate.createdAt.toIso8601String(),
      "updated_at": translate.updatedAt.toIso8601String(),
      "deleted_at": translate.deletedAt?.toIso8601String(),
    };

    print("Data before sending to server -============================ $word");

    final response = await Supabase.instance.client
        .from('translated_words')
        .insert(word)
        .select()
        .single();

    return response;
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
        "original": detailsWord["original"],
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
      print("From: ${translate.translateFrom?.code}");
      print("To: ${translate.translateTo?.code}");
      final res = await saveWord(translate);
      print("res from server ============= $res");
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

// Get translate words
class FetchTranslatedLibraryCubit extends Cubit<FetchTranslatedLibraryState> {
  FetchTranslatedLibraryCubit() : super(const FetchTranslatedLibraryState());

  Map libraryWords = {};

  void getLibrary() async {
    try {
      // If loaded before
      if (state.status == FetchTranslatedLibraryStatus.success) {
        emit(state.copyWith(
            status: FetchTranslatedLibraryStatus.success,
            libraryWords: List<Translate>.from(libraryWords.values)));
        return;
      }
      emit(state.copyWith(status: FetchTranslatedLibraryStatus.loading));
      //TODO update to get only words for this user
      final List<dynamic> data =
          await Supabase.instance.client.from('translated_words').select();
      List<Translate> words = data.map((e) => Translate.fromJson(e)).toList();
      // To load same list from local again next time
      for (final w in words) {
        libraryWords[w.id] = w;
      }

      for (final word in words) {
        print("id: ${word.id}, "
            "original: ${word.original}, "
            "translated: ${word.translated}, "
            "pos: ${word.pos}, "
            "pronunciation: ${word.pronunciation}, "
            "meaning: ${word.meaning}, "
            "examples: ${word.examples}, "
            "synonyms: ${word.synonyms}, "
            "from: ${word.translateFrom?.code}, "
            "to: ${word.translateTo?.code}, "
            "createdAt: ${word.createdAt}, "
            "updatedAt: ${word.updatedAt}, "
            "deletedAt: ${word.deletedAt}");
      }
      emit(state.copyWith(
          status: FetchTranslatedLibraryStatus.success, libraryWords: words));
    } catch (e) {
      emit(state.copyWith(status: FetchTranslatedLibraryStatus.failure));
    }
  }
}

// Auth
class AuthAppCubit extends Cubit<AuthAppState> {
  AuthAppCubit() : super(AuthAppState());

  // Login
  Future<void> login(String email, String password) async {
    try {
      emit(state.copyWith(status: AuthAppStatus.loading));

      // Empty
      if (email.isEmpty || password.isEmpty) {
        emit(state.copyWith(
            status: AuthAppStatus.error, errorType: AuthErrorType.emptyData));
        return;
      }

      // Email
      if (!email.trim().endsWith('@gmail.com')) {
        emit(state.copyWith(
            status: AuthAppStatus.error,
            errorType: AuthErrorType.invalidEmail));
        return;
      }

      // Password
      if (password.length < 8) {
        emit(state.copyWith(
            status: AuthAppStatus.error,
            errorType: AuthErrorType.shortPassword));
        return;
      }

      await Supabase.instance.client.auth
          .signInWithPassword(
            email: email.trim(),
            password: password.trim(),
          )
          .timeout(Duration(seconds: 15));
      emit(state.copyWith(status: AuthAppStatus.success));
    }
    //* Auth Errors
    on AuthException catch (e) {
      if (e.message.contains("Invalid login credentials")) {
        emit(state.copyWith(
            status: AuthAppStatus.error,
            errorType: AuthErrorType.wrongPassword));
      } else if (e.message.contains("SocketException") ||
          e.message.contains("Failed host lookup")) {
        emit(state.copyWith(
            status: AuthAppStatus.error, errorType: AuthErrorType.noInternet));
      }
    }
    //* Time out
    on TimeoutException catch (_) {
      emit(state.copyWith(
          status: AuthAppStatus.error, errorType: AuthErrorType.noInternet));
    } catch (e) {
      emit(state.copyWith(status: AuthAppStatus.error));
    }
  }

  // Sign up
  Future<void> signUp(
      String email, String password, String confirmPassword) async {
    try {
      emit(state.copyWith(status: AuthAppStatus.loading));

      // Empty
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        emit(state.copyWith(
            status: AuthAppStatus.error, errorType: AuthErrorType.emptyData));
        return;
      }

      // Email
      if (!email.trim().endsWith('@gmail.com')) {
        emit(state.copyWith(
            status: AuthAppStatus.error,
            errorType: AuthErrorType.invalidEmail));
        return;
      }

      // Password
      if (password.length < 8) {
        emit(state.copyWith(
            status: AuthAppStatus.error,
            errorType: AuthErrorType.shortPassword));
        return;
      }

      // Confirm password
      if (password != confirmPassword) {
        emit(state.copyWith(
            status: AuthAppStatus.error,
            errorType: AuthErrorType.wrongConfirmPassword));
        return;
      }

      // Sign up
      await Supabase.instance.client.auth
          .signUp(
            email: email.trim(),
            password: password.trim(),
          )
          .timeout(const Duration(seconds: 15));
      emit(state.copyWith(status: AuthAppStatus.success));
    }
    //* Auth Error
    on AuthException catch (e) {
      // Account Exist
      if (e.message.contains("User already registered")) {
        emit(state.copyWith(
            status: AuthAppStatus.error,
            errorType: AuthErrorType.accountExists));
      }
      // No internet
      else if (e.message.contains("SocketException") ||
          e.message.contains("Failed host lookup")) {
        emit(state.copyWith(
            status: AuthAppStatus.error, errorType: AuthErrorType.noInternet));
      }
    }
    //* Time out
    on TimeoutException catch (_) {
      emit(state.copyWith(
          status: AuthAppStatus.error, errorType: AuthErrorType.noInternet));
    }

    //* Other error
    catch (e) {
      print("Sign Up Error ======================== $e");
      emit(state.copyWith(status: AuthAppStatus.error));
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      emit(state.copyWith(status: AuthAppStatus.loading));
      await Supabase.instance.client.auth.signOut();
      emit(state.copyWith(status: AuthAppStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AuthAppStatus.error));
    }
  }

  // Launch
  Future<void> launch() async {
    try {
      emit(state.copyWith(status: AuthAppStatus.checkingSession));
      print("AP AUTH WORKING =================================");

      // Check current user
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        print("Current User ===============================");
        emit(state.copyWith(
          status: AuthAppStatus.authenticated,
        ));
      } else {
        print("unauthenticated User ===============================");
        emit(state.copyWith(status: AuthAppStatus.unauthenticated));
      }
    } catch (e) {
      print("ERROR User ===============================");
      emit(state.copyWith(status: AuthAppStatus.unauthenticated));
    }
  }
}
