import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  const AppCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.paddingM),
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusL)),
      child: child,
    );
  }
}
