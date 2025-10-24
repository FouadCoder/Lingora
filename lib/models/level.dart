import 'package:lingora/data/levels.dart';

class Level {
  int number;
  int requiredXp;

  Level({required this.number, required this.requiredXp});

  static Level getUserLevel(int xp) {
    // Check if user xp is greater than our levels
    if (xp >= levels.last.requiredXp) {
      return levels.last;
    }
    // XP >= requiredXp
    for (int i = levels.length - 1; i >= 0; --i) {
      if (xp >= levels[i].requiredXp) {
        return levels[i];
      }
    }
    // mean user is in level 1
    return levels.first;
  }

  static Level getNextLevel(int xp) {
    for (final level in levels) {
      if (xp < level.requiredXp) {
        return level; // first level with requiredXp > user's XP
      }
    }
    return levels.last; // user already maxed out
  }
}
