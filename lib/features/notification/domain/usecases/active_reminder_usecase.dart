import 'dart:math';

import 'package:lingora/features/notification/domain/repositories/notification_repository.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';

class ActiveReminderUseCase {
  final NotificationRepository repository;

  ActiveReminderUseCase(this.repository);

  Future call(WordEntity word) async {
    DateTime remindAt = getReminderTime();
    print("Random Time for reminder at =========== $remindAt");
    await Future.delayed(Duration(seconds: 1));
    return; //TODO update later
    // return repository.activeReminder(params);
  }

  DateTime getReminderTime() {
    Random random = Random();
    int randomDay = random.nextInt(7);
    int randomHour = random.nextInt(24);
    int randomMinute = random.nextInt(60);

    return DateTime.now().add(
        Duration(days: randomDay, hours: randomHour, minutes: randomMinute));
  }
}
