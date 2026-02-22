import 'package:lingora/features/notification/domain/entities/notification_entity.dart';

enum NotificationStatus {
  initial,
  loading,
  success,
  error,
  empty,
  networkError,
  validationError,
  limitExceeded,
}

class NotificationState {
  final NotificationStatus status;
  final NotificationStatus actionNotificationStatus;
  final String iconKeyword;
  final String title;
  final String message;
  final List<NotificationEntity> notifications;
  final bool isLoadingMore;
  final bool hasMore;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.actionNotificationStatus = NotificationStatus.initial,
    this.iconKeyword = 'bell',
    this.title = '',
    this.message = '',
    this.notifications = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    NotificationStatus? actionNotificationStatus,
    String? iconKeyword,
    String? title,
    String? message,
    List<NotificationEntity>? notifications,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return NotificationState(
      status: status ?? this.status,
      actionNotificationStatus:
          actionNotificationStatus ?? this.actionNotificationStatus,
      iconKeyword: iconKeyword ?? this.iconKeyword,
      title: title ?? this.title,
      message: message ?? this.message,
      notifications: notifications ?? this.notifications,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
