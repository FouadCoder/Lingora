import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/models/level.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Local Database
final db = Hive.box("db");

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
      await createProfile();

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

  // Create Profile
  Future<void> createProfile() async {
    //
    final String? userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      return;
    }

    await Supabase.instance.client.from('profiles').upsert(
      {'id': userId},
      onConflict: 'id', // do nothing if the profile already exists
    );
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

      print("Sign Up Email ======================== $email");

      // Sign up
      await Supabase.instance.client.auth
          .signUp(
            email: email.trim(),
            password: password.trim(),
          )
          .timeout(const Duration(seconds: 15));

      print("Sign Up Success ========================");

      // Create profile
      await createProfile();
      print("Profile Created ========================");
      emit(state.copyWith(status: AuthAppStatus.success));
    }
    //* Auth Error
    on AuthException catch (e) {
      print("Sign Up Error ======================== $e");
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

// Level
class LevelCubit extends Cubit<LevelState> {
  LevelCubit() : super(const LevelState());

  int _xp = 0;
  Level? _level;

  // Get XP from server
  Future<void> fetchXp() async {
    try {
      // check if success
      if (state.status == LevelStatus.success) {
        emit(state.copyWith(
          status: LevelStatus.success,
          level: _level,
          xp: _xp,
        ));
        return;
      }

      emit(state.copyWith(status: LevelStatus.loading));
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(status: LevelStatus.failure));
        return;
      }

      // Get XP
      final response = await Supabase.instance.client
          .from('user_analytics')
          .select('xp')
          .eq('user_id', userId)
          .isFilter('deleted_at', null)
          .single();

      // Get Current lvl , required xp to next level
      _xp = response['xp'] as int;
      _level = Level.getNextLevel(_xp);

      print(
          "=================================== XP: ${response['xp']} // Level ${_level!.number}   Requried XP ${_level!.requiredXp} ");
      emit(state.copyWith(
        status: LevelStatus.success,
        level: _level,
        xp: _xp,
      ));
    } catch (e) {
      print("=================================== Error getting XP: $e");
      emit(state.copyWith(
        status: LevelStatus.failure,
      ));
    }
  }

  // Clear XP
  void clear() {
    _xp = 0;
    _level = null;
    emit(const LevelState());
  }
}
