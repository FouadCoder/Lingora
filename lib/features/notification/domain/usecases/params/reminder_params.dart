class ReminderParams {
  final int? offset;
  final String userId;
  final String? wordId;
  final String? title;
  final String? message;
  final String? remindAt;
  final bool isActive;
  final String? reminderId;
  final String? original;
  final String? translated;
  ReminderParams(
      {required this.userId,
      this.wordId,
      this.title,
      this.message,
      this.remindAt,
      required this.isActive,
      this.reminderId,
      this.offset,
      this.original,
      this.translated});
}
