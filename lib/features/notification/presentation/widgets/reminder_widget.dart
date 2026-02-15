import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';

class ReminderWidget extends StatelessWidget {
  final String translate;
  final String original;
  final bool isActive;
  final ValueChanged<bool>? onChanged;

  const ReminderWidget({
    super.key,
    required this.translate,
    required this.original,
    required this.isActive,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    original,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  SizedBox(height: AppDimens.elementBetween),
                  Text(
                    translate,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            // Toggle switch
            SizedBox(width: AppDimens.paddingM),
            Switch(
              value: isActive,
              onChanged: onChanged,
              activeThumbColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
