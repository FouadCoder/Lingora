import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/extensions/theme_data.dart';
import 'package:lingora/widgets/shimmer_box.dart';

class LibraryLoadingCard extends StatefulWidget {
  const LibraryLoadingCard({super.key});

  @override
  State<LibraryLoadingCard> createState() => _LibraryLoadingCardState();
}

class _LibraryLoadingCardState extends State<LibraryLoadingCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: shimmerBox(
                  context,
                  height: theme.shimmerHeightTitleMedium,
                  width: double.infinity,
                  radius: theme.shimmerRadiusTitleMedium,
                ),
              ),
              SizedBox(width: AppDimens.subElementBetween),
              Expanded(
                child: shimmerBox(
                  context,
                  height: theme.shimmerHeightTitleMedium,
                  width: double.infinity,
                  radius: theme.shimmerRadiusTitleMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.sectionSpacing),
          shimmerBox(
            context,
            height: theme.shimmerHeightBodyMedium,
            width: double.infinity,
            radius: theme.shimmerRadiusBodyMedium,
          ),
          shimmerBox(
            context,
            height: theme.shimmerHeightBodyMedium,
            width: double.infinity,
            radius: theme.shimmerRadiusBodyMedium,
          ),
          shimmerBox(
            context,
            height: theme.shimmerHeightBodyMedium,
            width: double.infinity,
            radius: theme.shimmerRadiusBodyMedium,
          ),
          SizedBox(height: AppDimens.sectionSpacing),
          shimmerBox(
            context,
            height: theme.shimmerHeightBodySmall,
            width: 80,
            radius: theme.shimmerRadiusBodySmall,
          ),
        ],
      ),
    );
  }
}
