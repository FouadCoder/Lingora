import 'package:easy_localization/easy_localization.dart';

extension DateTimeExtension on DateTime {
  String toReadableDate() {
    return DateFormat('MMM d, yyyy').format(this);
  }

  String toDayAndShortMonth() {
    return DateFormat('d MMM').format(this); // e.g. "15 Sep"
  }

  String toMonthName() {
    return DateFormat('MMMM').format(this); // e.g. "September"
  }

  String toSmartTimeAgo() {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inMinutes < 2) {
      return 'time_just_now'.tr();
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} ${'time_minutes_ago'.tr()}";
    } else if (diff.inHours < 24 && now.day == day) {
      return 'time_today'.tr();
    } else if (diff.inHours < 48 && now.day - day == 1) {
      return 'time_yesterday'.tr();
    } else if (diff.inDays < 7) {
      return "${diff.inDays} ${'time_days_ago'.tr()}";
    } else if (diff.inDays < 14) {
      return 'time_week_ago'.tr();
    } else {
      return DateFormat('MMM d').format(this); // e.g. "Sep 15"
    }
  }
}
