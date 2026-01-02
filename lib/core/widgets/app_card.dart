import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final double padding;
  final Gradient? gradient;
  final List<BoxShadow>? shadow;

  const AppCard(
      {super.key,
      required this.child,
      this.backgroundColor,
      this.height,
      this.width,
      this.gradient,
      this.shadow,
      this.padding = AppDimens.paddingM});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
          boxShadow: shadow),
      child: child,
    );
  }
}
