import 'package:easy_localization/easy_localization.dart';

class Word {
  final String word;
  final String translation;
  final String type;
  final String definition;
  final String example;
  final String category;
  final DateTime transaltedTime;

  Word(
      {required this.word,
      required this.translation,
      required this.type,
      required this.definition,
      required this.example,
      required this.category,
      required this.transaltedTime});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['word'] ?? "no_word".tr(),
      translation: json['translation'] ?? "no_translation".tr(),
      type: json['type'] ?? '',
      definition: json['definition'] ?? '',
      example: json['example'] ?? '',
      category: json['category'] ?? '',
      transaltedTime:
          DateTime.tryParse(json['transaltedTime'] ?? '') ?? DateTime.now(),
    );
  }
}
