import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';

class IconCard extends StatelessWidget {
  final IconData icon;
  final Color? background;
  const IconCard({super.key, required this.icon, this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.paddingSS),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          color: background ??
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.07)),
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
        size: AppDimens.iconM,
      ),
    );
  }
}
