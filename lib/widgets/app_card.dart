import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  const AppCard({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusL)),
      child: child,
    );
  }
}
