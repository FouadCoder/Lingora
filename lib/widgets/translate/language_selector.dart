import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSelector extends StatelessWidget {
  final bool isSwapped;
  final VoidCallback onSwap;

  const LanguageSelector({
    super.key,
    required this.isSwapped,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Source Language
          Text(
            isSwapped ? 'sa_arabic'.tr() : 'us_english'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),

          // Swap Button
          GestureDetector(
            onTap: onSwap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.swap_horiz,
                color: theme.colorScheme.outline,
                size: 20,
              ),
            ),
          ),

          // Target Language
          Text(
            isSwapped ? 'us_english'.tr() : 'sa_arabic'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
