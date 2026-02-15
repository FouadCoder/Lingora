import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/exceptions/network_exception.dart';
import 'package:lingora/features/notification/domain/usecases/get_notification_usecase.dart';
import 'package:lingora/features/notification/domain/usecases/params/notification_params.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;

  NotificationCubit(
    this._getNotificationsUseCase,
  ) : super(NotificationState());

  int _offset = 0;
  DateTime? lastRefresh;

  Future<void> getNotifications() async {
    try {
      // If loaded before and has notifications, or already confirmed empty
      if (state.notifications.isNotEmpty ||
          state.status == NotificationStatus.empty) {
        emit(
          state.copyWith(
            status: state.notifications.isNotEmpty
                ? NotificationStatus.success
                : NotificationStatus.empty,
            notifications: state.notifications,
          ),
        );
        return;
      }

      emit(state.copyWith(status: NotificationStatus.loading));
      final notifications = await _getNotificationsUseCase(
        NotificationParams(offset: 0),
      );

      // If empty
      if (notifications.isEmpty) {
        emit(state.copyWith(status: NotificationStatus.empty));
        return;
      }

      //
      lastRefresh = DateTime.now();
      _offset = notifications.length;

      // Success
      emit(
        state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
        ),
      );
    } on NetworkException {
      emit(state.copyWith(status: NotificationStatus.networkError));
    } catch (_) {
      emit(state.copyWith(status: NotificationStatus.error));
    }
  }

  Future<void> loadMoreNotifications() async {
    try {
      if (state.isLoadingMore || !state.hasMore) {
        return;
      }

      emit(state.copyWith(
          isLoadingMore: true,
          actionNotificationStatus: NotificationStatus.initial));
      final notifications = await _getNotificationsUseCase(
        NotificationParams(offset: _offset),
      );

      // If empty
      if (notifications.isEmpty) {
        emit(state.copyWith(isLoadingMore: false, hasMore: false));
        return;
      }

      _offset = state.notifications.length + notifications.length;
      emit(
        state.copyWith(
          isLoadingMore: false,
          hasMore: notifications.length >= 15,
          notifications: [...state.notifications, ...notifications],
        ),
      );
    } on NetworkException {
      emit(
        state.copyWith(
          isLoadingMore: false,
          status: NotificationStatus.networkError,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(isLoadingMore: false, status: NotificationStatus.error),
      );
    }
  }

  Future<void> refreshNotifications() async {
    _offset = 0;
    DateTime now = DateTime.now();

    if (lastRefresh == null) {
      await getNotifications();
      return;
    }

    if (now.difference(lastRefresh!).inMinutes > 3) {
      await getNotifications();
    } else {
      emit(
        state.copyWith(
          actionNotificationStatus: NotificationStatus.limitExceeded,
        ),
      );
    }
  }
}
