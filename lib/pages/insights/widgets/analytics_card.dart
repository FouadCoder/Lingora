import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/shimmer_box.dart';

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
          overflow: TextOverflow.ellipsis,
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
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: AppDimens.sectionSpacing,
        ),
        // Icon
        SizedBox(
          height: 64,
          width: 64,
          child: Image.asset(iconName),
        )
      ],
    ));
  }
}

class AnalyticsCardLoading extends StatelessWidget {
  const AnalyticsCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          // Label placeholder
          shimmerBox(
            context,
            width: 60,
            height: 16,
          ),
          SizedBox(height: AppDimens.subElementBetween),
          // Icon placeholder
          shimmerBox(
            context,
            width: 64,
            height: 64,
            radius: 8,
          ),
        ],
      ),
    );
  }
}
