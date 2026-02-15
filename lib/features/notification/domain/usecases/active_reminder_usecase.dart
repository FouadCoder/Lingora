import 'dart:math';

import 'package:lingora/features/notification/data/reminder_templates.dart';
import 'package:lingora/features/notification/domain/repositories/notification_repository.dart';
import 'package:lingora/features/notification/domain/usecases/params/reminder_params.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';

class ActiveReminderUseCase {
  final NotificationRepository repository;

  ActiveReminderUseCase(this.repository);

  Future<void> call(WordEntity word) async {
    DateTime remindAt = getReminderTime();
    Map<String, String> notification = generateReminder(word);

    final params = ReminderParams(
      userId: word.userId,
      wordId: word.id,
      title: notification['title'],
      message: notification['message'],
      remindAt: remindAt.toIso8601String(),
      isActive: true,
    );

    return await repository.activeReminder(params);
  }

  DateTime getReminderTime() {
    Random random = Random();
    int randomDay = random.nextInt(7);
    int randomHour = random.nextInt(24);
    int randomMinute = random.nextInt(60);

    return DateTime.now().add(
        Duration(days: randomDay, hours: randomHour, minutes: randomMinute));
  }

  Map<String, String> generateReminder(WordEntity word) {
    // pick language from translateTo, default to English if null
    String lang = word.translateTo?.code ?? 'en';

    // get random template
    final titleTemplate =
        List<String>.from(reminderTitles[lang] ?? reminderTitles['en']!)
          ..shuffle();
    final messageTemplate =
        List<String>.from(reminderMessages[lang] ?? reminderMessages['en']!)
          ..shuffle();

    String title = titleTemplate.first.replaceAll('{word}', word.original);
    String message = messageTemplate.first
        .replaceAll('{word}', word.original)
        .replaceAll('{meaning}', word.meaning)
        .replaceAll(
            '{example}', word.examples.isNotEmpty ? word.examples.first : '')
        .replaceAll('{synonyms}', word.synonyms.join(', '));

    return {'title': title, 'message': message};
  }
}
