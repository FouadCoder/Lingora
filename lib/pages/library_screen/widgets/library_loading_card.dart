import 'package:easy_localization/easy_localization.dart';
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
      margin: const EdgeInsets.only(top: 2, bottom: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 0.010,
            offset: const Offset(0, 4),
          ),
        ],
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
              const SizedBox(width: 8),
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
          const SizedBox(height: 8),
          Text(
            "meaning".tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
            ),
          ),
          const SizedBox(height: 2),
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
          const SizedBox(height: 12),
          shimmerBox(
            context,
            height: theme.shimmerHeightBodySmall,
            width: 70,
            radius: theme.shimmerRadiusBodySmall,
          ),
        ],
      ),
    );
  }
}
