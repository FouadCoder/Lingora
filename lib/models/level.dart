import 'package:lingora/data/levels.dart';

class Level {
  int number;
  int requiredXp;

  Level({required this.number, required this.requiredXp});

  static Level getLevel(int xp) {
    // Check if user xp is greater than our levels
    if (xp >= levels.last.requiredXp) {
      return levels.last;
    }
    // XP >= requiredXp
    for (int i = levels.length; i >= 0; --i) {
      if (xp >= levels[i].requiredXp) {
        return levels[i];
      }
    }
    // mean user is in level 1
    return levels.first;
  }
}
