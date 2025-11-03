import 'package:lingora/models/level.dart';
import 'package:lingora/models/translate.dart';
import 'package:lingora/models/favorite.dart';
import 'package:lingora/models/user_analytics.dart';

// Get translate

enum FetchTranslatedLibraryStatus { initial, loading, success, failure, empty }

class FetchTranslatedLibraryState {
  final FetchTranslatedLibraryStatus status;
  final List<Translate> libraryWords;

  const FetchTranslatedLibraryState(
      {this.status = FetchTranslatedLibraryStatus.initial,
      this.libraryWords = const []});

  FetchTranslatedLibraryState copyWith({
    FetchTranslatedLibraryStatus? status,
    List<Translate>? libraryWords,
  }) {
    return FetchTranslatedLibraryState(
      status: status ?? this.status,
      libraryWords: libraryWords ?? this.libraryWords,
    );
  }
}

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

// History
enum FetchHistoryStatus { initial, loading, success, failure, empty }

class FetchHistoryState {
  final FetchHistoryStatus status;
  final Map history;

  const FetchHistoryState(
      {this.status = FetchHistoryStatus.initial, this.history = const {}});

  FetchHistoryState copyWith({
    FetchHistoryStatus? status,
    Map? history,
  }) {
    return FetchHistoryState(
      status: status ?? this.status,
      history: history ?? this.history,
    );
  }
}

// Favorites
enum FavoritesStatus { initial, loading, success, failure, empty }

enum FavoritesActionStatus { idle, loading, success, failure }

class FavoritesState {
  final FavoritesStatus status;
  final List<Favorite> favorites;
  final FavoritesActionStatus actionStatus;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const [],
    this.actionStatus = FavoritesActionStatus.idle,
  });

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<Favorite>? favorites,
    FavoritesActionStatus? actionStatus,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      actionStatus: actionStatus ?? this.actionStatus,
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

// User Analytics
enum UserAnalyticsStatus { initial, loading, success, failure }

class UserAnalyticsState {
  final UserAnalyticsStatus status;
  final UserAnalytics? userAnalytics;

  const UserAnalyticsState({
    this.status = UserAnalyticsStatus.initial,
    this.userAnalytics,
  });

  UserAnalyticsState copyWith({
    UserAnalyticsStatus? status,
    UserAnalytics? userAnalytics,
  }) {
    return UserAnalyticsState(
      status: status ?? this.status,
      userAnalytics: userAnalytics ?? this.userAnalytics,
    );
  }
}

// Category
enum CategoryStatus { initial, loading, success, failure }

class CategoryState {
  final CategoryStatus status;

  const CategoryState({
    this.status = CategoryStatus.initial,
  });

  CategoryState copyWith({
    CategoryStatus? status,
  }) {
    return CategoryState(
      status: status ?? this.status,
    );
  }
}
