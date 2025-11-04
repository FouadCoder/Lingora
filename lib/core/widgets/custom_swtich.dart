import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';

class CustomSwtich extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final ValueNotifier<bool> controller;
  final void Function(bool) onChanged;
  const CustomSwtich({
    super.key,
    required this.title,
    required this.description,
    required this.onChanged,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.onSurface,
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: AppDimens.iconM,
              ),
            ),
            SizedBox(width: AppDimens.elementBetween),
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
            ValueListenableBuilder<bool>(
              valueListenable: controller,
              builder: (context, value, _) {
                return Switch(
                  value: value,
                  onChanged: (val) {
                    controller.value = val;
                    onChanged(val);
                  },
                  activeThumbColor: Theme.of(context).colorScheme.secondary,
                  inactiveThumbColor: theme.colorScheme.surface,
                  inactiveTrackColor: theme.colorScheme.outline,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
