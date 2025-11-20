import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/custom_status.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_state.dart';
import 'package:lingora/features/analytics/presentation/widgets/heatmap_card.dart';

class InsightsHeatmapWidget extends StatefulWidget {
  const InsightsHeatmapWidget({super.key});

  @override
  State<InsightsHeatmapWidget> createState() => _InsightsHeatmapWidgetState();
}

class _InsightsHeatmapWidgetState extends State<InsightsHeatmapWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, UserAnalyticsState>(
      builder: (context, state) {
        // Loading
        if (state.dailyActivityStatus == UserAnalyticsRequestStatus.loading) {
          return CustomState(
              animation: 'assets/animation/loading_star.json',
              title: '',
              message: 'loading_analytics'.tr());
        }

        // Success
        if (state.dailyActivityStatus == UserAnalyticsRequestStatus.success) {
          final dailyActivity = state.dailyActivity;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${"activity_in".tr()} 2025",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/analysis/details', extra: dailyActivity);
                    },
                    child: Text(
                      "see_details".tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppDimens.sectionSpacing,
              ),
              // Analytics
              SizedBox(
                height: 270,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final now = DateTime.now();
                    final year = now.year;
                    final month = index + 1;
                    final minDate = DateTime(year, month, 1);
                    final maxDate = DateTime(year, month + 1, 0);

                    // Get month name, e.g., "Nov"
                    final monthName = DateFormat.MMM().format(minDate);

                    // Get entries for this year & month
                    final monthEntries = dailyActivity?[year]?[monthName] ?? [];

                    // Convert to ContributionEntry
                    final contributions = monthEntries
                        .map((e) =>
                            ContributionEntry(e.date, e.totalTranslations))
                        .toList();

                    // Heatmap Card
                    return Padding(
                      padding: EdgeInsets.only(right: AppDimens.cardBetween),
                      child: HeatmapCard(
                          minDate: minDate,
                          maxDate: maxDate,
                          totalTranslations: 0,
                          activeDays: 0,
                          cellSize: 20,
                          cellRadius: 2,
                          hideDetails: true,
                          entries: contributions),
                    );
                  },
                ),
              ),
            ],
          );
        }

        // Error
        if (state.dailyActivityStatus == UserAnalyticsRequestStatus.failure) {
          return Container();
        }
        return Container();
      },
    );
  }
}
