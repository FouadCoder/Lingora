import 'package:lingora/models/level.dart';

// Auth

enum AuthAppStatus {
  initial,
  loading,
  success,
  error,
  checkingSession,
  authenticated,
  unauthenticated,
}

enum AuthErrorType {
  wrongPassword,
  wrongConfirmPassword,
  shortPassword,
  emptyData,
  invalidEmail,
  noInternet,
  accountExists
}

class AuthAppState {
  final AuthAppStatus status;
  final AuthErrorType? errorType; // only set if status == error

  AuthAppState({
    this.status = AuthAppStatus.initial,
    this.errorType,
  });

  AuthAppState copyWith({
    AuthAppStatus? status,
    AuthErrorType? errorType,
  }) {
    return AuthAppState(
      status: status ?? this.status,
      errorType: errorType ?? this.errorType,
    );
  }
}

// Level
enum LevelStatus { initial, loading, success, failure }

// In state_app.dart
class LevelState {
  final LevelStatus status;
  final Level? level;
  final int? xp;

  const LevelState({
    this.status = LevelStatus.initial,
    this.level,
    this.xp,
  });

  LevelState copyWith({
    LevelStatus? status,
    Level? level,
    int? xp,
  }) {
    return LevelState(
      status: status ?? this.status,
      level: level ?? this.level,
      xp: xp ?? this.xp,
    );
  }
}
