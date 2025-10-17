import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/widgets/app_card.dart';

class ShortcutWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  const ShortcutWidget({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      height: 90,
      child: Column(
        children: [
          // Icon
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          SizedBox(height: AppDimens.elementBetween),
          // Text
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
