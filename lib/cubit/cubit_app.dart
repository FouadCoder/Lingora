import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/keys.dart';
import 'package:lingora/models/level.dart';
import 'package:lingora/models/translate.dart';
import 'package:lingora/models/favorite.dart';
import 'package:lingora/models/user_analytics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Local Database
final db = Hive.box("db");

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
          .eq('user_id', userId)
          .isFilter('deleted_at', null);
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

      // Sign up
      await Supabase.instance.client.auth
          .signUp(
            email: email.trim(),
            password: password.trim(),
          )
          .timeout(const Duration(seconds: 15));

      // Create profile
      await createProfile();
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

// History
class HistoryCubit extends Cubit<FetchHistoryState> {
  HistoryCubit() : super(FetchHistoryState());

  Map history = {};

  // Group data by date
  Map groupByDate(List data) {
    final Map datesGroups = {};
    final Set<String> datesIDS = {};
    print("Data before grouping ============ ${data.length}");

    for (var item in data) {
      // Give it to translate model
      var newItem = Translate.fromJson(item);

      final createdAt = newItem.createdAt;
      final dateKey =
          "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}";

      if (!datesIDS.contains(dateKey)) {
        datesGroups[dateKey] = [];
        datesIDS.add(dateKey);
      }

      // Add item to the list of that date
      datesGroups[dateKey]!.add(newItem);
      print(
          "Item ADDED =================== ${newItem.createdAt} ========= ID ---- ${newItem.id}");
    }

    return datesGroups;
  }

  // Sort grouped data by date (most recent first) and sort items within each date
  Map sortGroupedData(Map groupedData) {
    // Convert to list of entries for sorting
    final List<MapEntry<dynamic, dynamic>> entries =
        groupedData.entries.toList();

    // Sort by date key (most recent first)
    entries.sort((a, b) => b.key.toString().compareTo(a.key.toString()));

    // Sort items within each date group by creation time (most recent first)
    for (var entry in entries) {
      final List<Translate> items = List<Translate>.from(entry.value);
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      entry.value.clear();
      entry.value.addAll(items);
    }

    // Convert back to map
    final Map<String, List<Translate>> sortedData = {};
    for (var entry in entries) {
      sortedData[entry.key.toString()] = List<Translate>.from(entry.value);
    }

    return sortedData;
  }

  // Fetch history
  Future<void> fetchHistory() async {
    try {
      // check if loaded
      if (state.status == FetchHistoryStatus.success) {
        emit(state.copyWith(
            status: FetchHistoryStatus.success, history: history));
        return;
      }

      emit(state.copyWith(status: FetchHistoryStatus.loading));
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final res = await Supabase.instance.client
          .from("translate_history")
          .select()
          .eq("user_id", userId)
          .isFilter('deleted_at', null);

      Map historyGroups = groupByDate(res);
      // If empty
      if (historyGroups.isEmpty) {
        emit(state.copyWith(
          status: FetchHistoryStatus.empty,
        ));
        return;
      }

      // Sort the grouped data
      Map sortedHistoryGroups = sortGroupedData(historyGroups);
      history.addAll(sortedHistoryGroups);
      // Success
      emit(state.copyWith(
          status: FetchHistoryStatus.success, history: sortedHistoryGroups));
    } catch (e) {
      print("Error getting history ------------------ $e");
      emit(state.copyWith(status: FetchHistoryStatus.failure));
    }
  }
}

// Favorites
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesState());

  Map<String, Favorite> favoritesMap = {};

  // Get user's favorites (only non-deleted ones)
  Future<void> getFavorites() async {
    try {
      // If already loaded, return cached data
      if (state.status == FavoritesStatus.success ||
          state.status == FavoritesStatus.empty) {
        if (state.status == FavoritesStatus.empty) {
          emit(state.copyWith(status: FavoritesStatus.empty));
          return;
        }
        // Success - return cached data
        emit(state.copyWith(
          status: FavoritesStatus.success,
          favorites: List<Favorite>.from(favoritesMap.values),
        ));
        return;
      }

      emit(state.copyWith(status: FavoritesStatus.loading));

      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(status: FavoritesStatus.failure));
        return;
      }

      // Get favorites with joined translated_words data
      final List<dynamic> data = await Supabase.instance.client
          .from('favorites')
          .select('''
            *,
            translated_words:translated_word_id(*)
          ''')
          .eq('user_id', userId)
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false);

      List<Favorite> favorites = data.map((e) => Favorite.fromJson(e)).toList();

      // Update local map
      favoritesMap.clear();
      for (final favorite in favorites) {
        favoritesMap[favorite.id] = favorite;
      }

      if (favorites.isEmpty) {
        print("Empty Favorites ==================== $favorites");
        emit(state.copyWith(status: FavoritesStatus.empty));
        return;
      }
      print("Len ====================== ${favorites.length}");
      print("Success Favorites ==================== $favorites");
      emit(state.copyWith(
        status: FavoritesStatus.success,
        favorites: favorites,
      ));
    } catch (e) {
      print("Error getting favorites: $e");
      emit(state.copyWith(status: FavoritesStatus.failure));
    }
  }

  // Add a word to favorites
  Future<void> addToFavorites(String translatedWordId) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(status: FavoritesStatus.failure));
        return;
      }

      // Use upsert to add or restore favorite
      final result = await Supabase.instance.client.from('favorites').upsert({
        'user_id': userId,
        'translated_word_id': translatedWordId,
        'deleted_at': null,
      }).select('''
            *,
            translated_words:translated_word_id(*)
          ''').single();

      // Create favorite object from result
      final newFavorite = Favorite.fromJson(result);

      // Add to local map
      favoritesMap[newFavorite.id] = newFavorite;

      // Update state with new favorites list
      emit(state.copyWith(
        status: FavoritesStatus.success,
        favorites: List<Favorite>.from(favoritesMap.values),
      ));
    } catch (e) {
      print(" ===================== Error adding to favorites: $e");
      emit(state.copyWith(actionStatus: FavoritesActionStatus.failure));
    }
  }

  // Remove a word from favorites (soft delete)
  Future<void> removeFromFavorites(String translatedWordId) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(status: FavoritesStatus.failure));
        return;
      }

      // Soft delete the favorite
      await Supabase.instance.client
          .from('favorites')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId)
          .eq('translated_word_id', translatedWordId)
          .isFilter('deleted_at', null);

      // Remove from local map
      favoritesMap.removeWhere(
          (key, favorite) => favorite.translatedWordId == translatedWordId);

      // Update state with updated favorites list
      final updatedFavorites = List<Favorite>.from(favoritesMap.values);

      if (updatedFavorites.isEmpty) {
        emit(state.copyWith(status: FavoritesStatus.empty));
      } else {
        emit(state.copyWith(
          status: FavoritesStatus.success,
          favorites: updatedFavorites,
        ));
      }
    } catch (e) {
      print("Error removing from favorites: $e");
      emit(state.copyWith(actionStatus: FavoritesActionStatus.failure));
    }
  }

  // Clear local favorites map
  void clearFavoritesMap() {
    favoritesMap.clear();
    emit(state.copyWith(status: FavoritesStatus.initial));
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

// Analytics
class AnalyticsCubit extends Cubit<UserAnalyticsState> {
  AnalyticsCubit() : super(const UserAnalyticsState());

  UserAnalytics? _userAnalytics;

  // Get analysis
  Future<void> getAnalysis() async {
    try {
      // check if success
      if (state.status == UserAnalyticsStatus.success) {
        emit(state.copyWith(
          status: UserAnalyticsStatus.success,
          userAnalytics: _userAnalytics,
        ));
        return;
      }

      emit(state.copyWith(status: UserAnalyticsStatus.loading));
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        emit(state.copyWith(status: UserAnalyticsStatus.failure));
        return;
      }

      // Get analysis
      final response = await Supabase.instance.client
          .from('user_analytics')
          .select('total_translations, total_library_words, active_days, xp')
          .eq('user_id', userId)
          .isFilter('deleted_at', null)
          .single();

      _userAnalytics = UserAnalytics.fromJson(response);
      emit(state.copyWith(
        status: UserAnalyticsStatus.success,
        userAnalytics: _userAnalytics,
      ));
    } catch (e) {
      print("=========== Error getting analytics: $e");
      emit(state.copyWith(status: UserAnalyticsStatus.failure));
    }
  }
}

// Category
class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(const CategoryState());

  // Save category in local
  Future<Map> saveCategoryLocal(String userId, String categoryName) async {
    List categories = [];
    Map category = {};
    DateTime now = DateTime.now();
    bool requestFromServer = false;

    // Get last updated time
    DateTime? lastUpdated = await db.get("lastUpdateCategory");
    if (lastUpdated == null) {
      requestFromServer = true;
    }

    // Check if more than 7 days
    if (lastUpdated != null) {
      final diff = now.difference(lastUpdated);
      if (diff.inDays > 7) {
        requestFromServer = true;
      }
    }

    // If request from server
    if (requestFromServer) {
      final res = await Supabase.instance.client
          .from('categories')
          .select('id , name')
          .eq("user_id", userId)
          .isFilter('deleted_at', null);
      categories = res;

      // Save categories in local
      await db.put("categories", categories);
      await db.put("lastUpdateCategory", DateTime.now());

      print("Server  =================== Categories: $categories");
    }

    // request from local
    if (!requestFromServer) {
      categories = await db.get("categories");
      print("Local  =================== Categories: $categories");
    }

    category =
        categories.where((element) => element['name'] == categoryName).first;
    return category;
  }

  // Add word to category
  Future<void> addWordToCategory(String wordId, String categoryName) async {
    try {
      emit(state.copyWith(status: CategoryStatus.loading));
      // Check ID
      if (wordId.isEmpty || categoryName.isEmpty) {
        emit(state.copyWith(status: CategoryStatus.failure));
        return;
      }
      // User Id
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(status: CategoryStatus.failure));
        return;
      }
      // Get category Id
      Map category = await saveCategoryLocal(userId, categoryName);
      // Update word category
      await Supabase.instance.client
          .from('translated_words')
          .update({'category_id': category['id']})
          .eq('id', wordId)
          .isFilter('deleted_at', null);

      print(
          "===================== $wordId // $categoryName // Category Id ==== ${category['id']}");

      emit(state.copyWith(status: CategoryStatus.success));
    } catch (e) {
      print("============================== Error adding word to category: $e");
      emit(state.copyWith(status: CategoryStatus.failure));
    }
  }
}
