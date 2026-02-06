class ReminderParams {
  final int? offset;
  final String userId;
  final String? wordId;
  final String? title;
  final String? message;
  final String? remindAt;
  final String isActive;
  final String reminderId;
  ReminderParams(this.userId, this.wordId, this.title, this.message,
      this.remindAt, this.isActive, this.reminderId,
      {required this.offset});
}
