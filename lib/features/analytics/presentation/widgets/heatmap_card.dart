import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/core/extensions/datetime_style.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/features/analytics/presentation/widgets/activity_heatmap.dart';

class HeatmapCard extends StatelessWidget {
  final DateTime minDate;
  final DateTime maxDate;
  final int totalTranslations;
  final int activeDays;
  final double cellSize;
  final double cellRadius;
  final bool hideDetails;
  final List<ContributionEntry> entries;
  const HeatmapCard(
      {super.key,
      required this.minDate,
      required this.maxDate,
      required this.totalTranslations,
      required this.activeDays,
      this.cellSize = 15,
      this.cellRadius = 8,
      this.hideDetails = false,
      required this.entries});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month name
          Text(
            minDate.toMonthName(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (!hideDetails)
            SizedBox(
              height: AppDimens.sectionSpacing,
            ),
          if (!hideDetails)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Total translation
                Row(
                  children: [
                    // Number
                    Text(
                      totalTranslations.toString(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: AppDimens.buttonTagHorizontal,
                    ),

                    Text(
                      'total_translations'.tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                SizedBox(
                  width: AppDimens.buttonTagHorizontal,
                ),

                // Active days
                Row(
                  children: [
                    Text(
                      activeDays.toString(),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: AppDimens.buttonTagHorizontal,
                    ),
                    Text(
                      'active_days'.tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
          SizedBox(
            height: AppDimens.sectionSpacing,
          ),
          // Activity
          Center(
            child: ActivityHeatmap(
                minDate: minDate,
                maxDate: maxDate,
                cellSize: cellSize,
                cellRadius: cellRadius,
                splittedMonthView: true,
                showMonthLabels: false,
                showWeekdayLabels: true,
                entries: entries),
          ),
        ],
      ),
    );
  }
}
