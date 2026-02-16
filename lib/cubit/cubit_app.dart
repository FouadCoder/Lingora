import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/models/level.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Local Database
final db = Hive.box("db");

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

      emit(state.copyWith(
        status: LevelStatus.success,
        level: _level,
        xp: _xp,
      ));
    } catch (e) {
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
