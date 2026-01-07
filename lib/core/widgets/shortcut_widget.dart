import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';

class ShortcutWidget extends StatelessWidget {
  final HeroIcons icon;
  final String text;
  final VoidCallback? onTap;
  const ShortcutWidget(
      {super.key, required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        height: 85,
        shadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            HeroIcon(
              icon,
              size: AppDimens.iconXL,
              color: Theme.of(context).iconTheme.color,
            ),

            SizedBox(height: AppDimens.elementBetween),
          ],
        ),
      ),
    );
  }
}
