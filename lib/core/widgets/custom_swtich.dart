import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/icon_card.dart';

class CustomSwtich extends StatelessWidget {
  final String title;
  final String description;
  final HeroIcons? icon;
  final ValueNotifier<bool> controller;
  final void Function(bool) onChanged;
  final bool isLoading;
  const CustomSwtich({
    super.key,
    required this.title,
    required this.description,
    required this.onChanged,
    required this.controller,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            IconCard(icon: icon!),
            SizedBox(width: AppDimens.subElementBetween),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: AppDimens.elementBetween),
                Text(
                  description,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimens.elementBetween),
          isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              : ValueListenableBuilder<bool>(
                  valueListenable: controller,
                  builder: (context, value, _) {
                    return Switch(
                      value: value,
                      onChanged: (val) {
                        controller.value = val;
                        onChanged(val);
                      },
                      activeThumbColor: theme.colorScheme.primary,
                      inactiveThumbColor: theme.colorScheme.surface,
                      inactiveTrackColor: theme.colorScheme.outline,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  },
                ),
        ],
      ),
    );
  }
}
