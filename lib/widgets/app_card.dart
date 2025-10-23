import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final Gradient? gradient;
  const AppCard(
      {super.key,
      required this.child,
      this.backgroundColor,
      this.height,
      this.width,
      this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppDimens.radiusL)),
      child: child,
    );
  }
}
