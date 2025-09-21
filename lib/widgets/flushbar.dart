import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context, {
  String? title,
  String? message,
  IconData? icon,
  Color? iconColor,
}) {
  Flushbar(
    title: (title?.isEmpty ?? true) ? null : title,
    message: message, // if it's null, Flushbar just won’t show it
    icon: icon != null ? Icon(icon, color: iconColor) : null,
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(16),
    duration: const Duration(seconds: 4),
    flushbarPosition: FlushbarPosition.BOTTOM,
    shouldIconPulse: false,
    backgroundColor: Theme.of(context).colorScheme.onPrimary,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    borderRadius: BorderRadius.circular(12),
  ).show(context);
}
