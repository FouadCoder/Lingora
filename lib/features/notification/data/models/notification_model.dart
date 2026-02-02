import 'package:lingora/features/notification/domain/entities/notification_entity.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String? iconKeyword;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.iconKeyword,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? "",
      message: json['message'] ?? "",
      iconKeyword: json['icon'] ?? "bell",
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      message: message,
      iconKeyword: iconKeyword,
      createdAt: createdAt,
    );
  }
}
