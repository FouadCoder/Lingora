import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/icon_card.dart';
import 'package:lingora/core/widgets/shimmer_box.dart';

class NotificationLoadingCard extends StatefulWidget {
  const NotificationLoadingCard({super.key});

  @override
  State<NotificationLoadingCard> createState() =>
      _NotificationLoadingCardState();
}

class _NotificationLoadingCardState extends State<NotificationLoadingCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconCard(
              icon: HeroIcons.bell,
              iconColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(context, width: 200),
                SizedBox(height: AppDimens.elementBetween),
                shimmerBox(context),
                SizedBox(height: AppDimens.sectionSpacing),
                Align(
                  alignment: AlignmentGeometry.bottomRight,
                  child: shimmerBox(context, width: 60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
