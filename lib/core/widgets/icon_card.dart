import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';

class IconCard extends StatelessWidget {
  final HeroIcons icon;
  final Color? background;
  final Color? iconColor;
  final VoidCallback? onTap;
  const IconCard(
      {super.key,
      required this.icon,
      this.background,
      this.onTap,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimens.paddingS),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
            border: Border(
                top: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.1)),
                bottom: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.1))),
            color: background ?? Theme.of(context).colorScheme.onSurface),
        child: HeroIcon(
          icon,
          color: iconColor ?? Theme.of(context).iconTheme.color,
          size: AppDimens.iconL,
        ),
      ),
    );
  }
}
