import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/shimmer_box.dart';

class AnalyticsCard extends StatelessWidget {
  final String label;
  final String analytics;
  final String iconName;
  final bool isLoading;
  const AnalyticsCard(
      {super.key,
      required this.label,
      required this.analytics,
      required this.iconName,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return AppCard(
        child: Column(
      children: [
        // label
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: AppDimens.subElementBetween,
        ),
        // Analytics numebr
        if (!isLoading)
          Text(
            analytics,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary),
            overflow: TextOverflow.ellipsis,
          ),
        // If loading
        if (isLoading) shimmerBox(context, width: 30, height: 30, radius: 6),
        SizedBox(
          height: AppDimens.sectionSpacing,
        ),
        // Icon
        SizedBox(
          height: 80,
          width: 80,
          child: Image.asset(iconName),
        )
      ],
    ));
  }
}
