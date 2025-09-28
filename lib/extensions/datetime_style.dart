import 'package:easy_localization/easy_localization.dart';

extension DateTimeExtension on DateTime {
  String toReadableDate() {
    return DateFormat('MMM d, yyyy').format(this);
  }

  String toMonthName() {
    return DateFormat('MMMM').format(this); // e.g. "September"
  }
}
