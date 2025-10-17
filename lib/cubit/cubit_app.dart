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

  //translation
  Future<void> translate() async {
    try {
      if (state.inputText.trim().isEmpty) {
        emit(state.copyWith(status: TranslateStatus.empty));
        return;
      }
      emit(state.copyWith(status: TranslateStatus.loading));
      print("Start loading =====================================");
      final userId = Supabase.instance.client.auth.currentUser?.id;
      final from = (state.sourceLanguage.code);
      final to = (state.targetLanguage.code);

      // Translate
      final res =
          await Supabase.instance.client.functions.invoke('translate', body: {
        "user_id": userId,
        "input": state.inputText,
        "translate_from": from,
        "translate_to": to,
      });
      final data = res.data;
      print("Input ============== ${state.inputText}");
      print("Data ================ $data");
      Translate translate = Translate.fromJson(data);

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
      if (state.status == FetchTranslatedLibraryStatus.success ||
          state.status == FetchTranslatedLibraryStatus.empty) {
        // Empty
        if (state.status == FetchTranslatedLibraryStatus.empty) {
          emit(state.copyWith(status: FetchTranslatedLibraryStatus.empty));
          return;
        }

        // Success
        emit(state.copyWith(
            status: FetchTranslatedLibraryStatus.success,
            libraryWords: List<Translate>.from(libraryWords.values)));
        return;
      }

      emit(state.copyWith(status: FetchTranslatedLibraryStatus.loading));
      final userId = Supabase.instance.client.auth.currentUser?.id;
      // If user is not logged in
      if (userId == null) {
        emit(state.copyWith(
          status: FetchTranslatedLibraryStatus.failure,
        ));
        return;
      }

      // Get
      final List<dynamic> data = await Supabase.instance.client
          .from('translated_words')
          .select()
          .eq('user_id', userId);
      List<Translate> words = data.map((e) => Translate.fromJson(e)).toList();
      // To load same list from local again next time
      for (final w in words) {
        libraryWords[w.id] = w;
      }

      // If empty
      if (words.isEmpty) {
        emit(state.copyWith(
          status: FetchTranslatedLibraryStatus.empty,
        ));
        return;
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

      // Create profile & Analytics & Check if exist
      await createProfileAndAnalytics();

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
      print("Error ============================= $e");
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client.auth.signOut();
      }
      emit(state.copyWith(status: AuthAppStatus.error));
    }
  }

  // Create Profile & Analytics for new user
  Future<void> createProfileAndAnalytics() async {
    // Profile
    final String? userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      return;
    }
    bool profileExist = false;
    bool analyticsExist = false;

    final data = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (data != null) {
      profileExist = true;
    }

    if (!profileExist) {
      await Supabase.instance.client.from('profiles').upsert({
        'id': userId,
      });
    }

    // Analytics
    final analyticsData = await Supabase.instance.client
        .from('user_analytics')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (analyticsData != null) {
      analyticsExist = true;
    }

    if (!analyticsExist) {
      await Supabase.instance.client
          .from('user_analytics')
          .upsert({'user_id': userId, 'total_translations': 0});
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

      // Create profile & Analytics
      await createProfileAndAnalytics();
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
      // Logout if error happened to avoid missing the profile
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        await Supabase.instance.client.auth.signOut();
      }
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
