import 'package:lingora/features/analytics/domain/entities/daily_activity_entity.dart';

class DailyActivityModel {
  final DateTime date;
  final int totalTranslations;

  DailyActivityModel({required this.date, required this.totalTranslations});

  factory DailyActivityModel.fromJson(Map<String, dynamic> json) {
    return DailyActivityModel(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      totalTranslations: json['translations_count'] ?? 0,
    );
  }

  DailyActivityEntity toEntity() {
    return DailyActivityEntity(
      date: date,
      totalTranslations: totalTranslations,
    );
  }
}
