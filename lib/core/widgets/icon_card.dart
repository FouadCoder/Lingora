import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';

class IconCard extends StatelessWidget {
  final IconData icon;
  final Color? background;
  final VoidCallback? onTap;
  const IconCard({super.key, required this.icon, this.background, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimens.paddingS),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            color: background ?? Theme.of(context).colorScheme.onSurface),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: AppDimens.iconM,
        ),
      ),
    );
  }
}
