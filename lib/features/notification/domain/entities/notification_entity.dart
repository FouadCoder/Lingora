class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String? iconKeyword;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    this.iconKeyword,
    required this.createdAt,
  });
}
