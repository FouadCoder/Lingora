import 'package:easy_localization/easy_localization.dart';

extension DateStringExtension on String {
  String toReadableDate() {
    final date = DateTime.parse(this);
    return DateFormat('MMM d, yyyy').format(date);
  }

  String toMonthName() {
    final date = DateTime.parse(this);
    return DateFormat('MMMM').format(date); // e.g. "September"
  }
}
