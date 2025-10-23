import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/widgets/app_card.dart';

class ShortcutWidget extends StatelessWidget {
  final IconData icon;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
            SizedBox(height: AppDimens.elementBetween),
            // Text
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
