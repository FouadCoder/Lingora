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

class AuthState {
  final AuthAppStatus status;
  final AuthErrorType? errorType;

  AuthState({
    this.status = AuthAppStatus.initial,
    this.errorType,
  });

  AuthState copyWith({
    AuthAppStatus? status,
    AuthErrorType? errorType,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorType: errorType ?? this.errorType,
    );
  }
}
