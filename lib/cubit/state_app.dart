import 'package:lingora/models/level.dart';

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
