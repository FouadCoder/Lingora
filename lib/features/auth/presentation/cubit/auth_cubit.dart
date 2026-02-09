import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/auth/domain/usecases/login_usecase.dart';
import 'package:lingora/features/auth/domain/usecases/signup_usecase.dart';
import 'package:lingora/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lingora/features/auth/domain/usecases/check_session_usecase.dart';
import 'package:lingora/features/auth/domain/usecases/create_profile_usecase.dart';
import 'package:lingora/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckSessionUseCase _checkSessionUseCase;
  final CreateProfileUseCase _createProfileUseCase;

  AuthCubit(
    this._loginUseCase,
    this._signUpUseCase,
    this._logoutUseCase,
    this._checkSessionUseCase,
    this._createProfileUseCase,
  ) : super(AuthState());

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

      await _loginUseCase(email.trim(), password.trim());

      // Create profile & Analytics & Check if exist
      await _createProfileUseCase();

      emit(state.copyWith(status: AuthAppStatus.success));
    }
    //* Time out
    on TimeoutException catch (_) {
      emit(state.copyWith(
          status: AuthAppStatus.error, errorType: AuthErrorType.noInternet));
    }
    //* Auth Errors
    catch (e) {
      if (e.toString().contains("Invalid login credentials")) {
        emit(state.copyWith(
            status: AuthAppStatus.error,
            errorType: AuthErrorType.wrongPassword));
      } else if (e.toString().contains("SocketException") ||
          e.toString().contains("Failed host lookup")) {
        emit(state.copyWith(
            status: AuthAppStatus.error, errorType: AuthErrorType.noInternet));
      } else {
        print("Error ============================= $e");
        emit(state.copyWith(status: AuthAppStatus.error));
      }
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
      await _signUpUseCase(email.trim(), password.trim());

      // Create profile
      await _createProfileUseCase();
      emit(state.copyWith(status: AuthAppStatus.success));
    }
    //* Time out
    on TimeoutException catch (_) {
      emit(state.copyWith(
          status: AuthAppStatus.error, errorType: AuthErrorType.noInternet));
    }
    //* Auth Error
    catch (e) {
      // Account Exist
      if (e.toString().contains("User already registered")) {
        emit(state.copyWith(
            status: AuthAppStatus.error,
            errorType: AuthErrorType.accountExists));
      }
      // No internet
      else if (e.toString().contains("SocketException") ||
          e.toString().contains("Failed host lookup")) {
        emit(state.copyWith(
            status: AuthAppStatus.error, errorType: AuthErrorType.noInternet));
      } else {
        emit(state.copyWith(status: AuthAppStatus.error));
      }
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      emit(state.copyWith(status: AuthAppStatus.loading));
      await _logoutUseCase();
      emit(state.copyWith(status: AuthAppStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AuthAppStatus.error));
    }
  }

  // Launch
  Future<void> launch() async {
    try {
      emit(state.copyWith(status: AuthAppStatus.checkingSession));

      // Check current user
      final session = await _checkSessionUseCase();
      if (session != null) {
        emit(state.copyWith(
          status: AuthAppStatus.authenticated,
        ));
      } else {
        emit(state.copyWith(status: AuthAppStatus.unauthenticated));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthAppStatus.unauthenticated));
    }
  }
}
