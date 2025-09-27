import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/widgets/app_card.dart';

class AnalyticsCard extends StatelessWidget {
  final String label;
  final String analytics;
  final String iconName;
  const AnalyticsCard(
      {super.key,
      required this.label,
      required this.analytics,
      required this.iconName});

  @override
  Widget build(BuildContext context) {
    return AppCard(
        child: Column(
      children: [
        // label
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(
          height: AppDimens.subElementBetween,
        ),
        // Analytics numebr/text
        Text(
          analytics,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        SizedBox(
          height: AppDimens.sectionSpacing,
        ),
        // Icon
        SizedBox(
          height: 100,
          width: 100,
          child: Image.asset(iconName),
        )
      ],
    ));
  }
}
