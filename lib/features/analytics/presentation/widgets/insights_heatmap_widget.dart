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
import 'package:lingora/features/analytics/domain/entities/month_activity_entity.dart';

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
        if (state.monthlyActivityStatus == UserAnalyticsRequestStatus.loading) {
          return CustomState(
            animation: 'assets/animation/loading_star.json',
            title: '',
            message: 'loading_analytics'.tr(),
          );
        }

        // Error
        if (state.monthlyActivityStatus == UserAnalyticsRequestStatus.failure) {
          return Container();
        }

        final monthlyActivity = state.monthlyActivity;
        if (monthlyActivity == null || monthlyActivity.isEmpty) {
          return Container();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: monthlyActivity.keys.length,
          itemBuilder: (context, yearIndex) {
            final year = monthlyActivity.keys.elementAt(yearIndex);
            final months = monthlyActivity[year]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${"activity_in".tr()} $year",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push('/analysis/details',
                            extra: monthlyActivity);
                      },
                      child: Text(
                        "see_details".tr(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.sectionSpacing),
                SizedBox(
                  height: 270,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 12, // always 12 months
                    itemBuilder: (context, monthIndex) {
                      final monthNumber = monthIndex + 1;

                      // Find MonthActivityEntity for this month
                      final monthData = months.firstWhere(
                        (m) => m.month.month == monthNumber,
                        orElse: () => MonthActivityEntity(
                          month: DateTime(year, monthNumber),
                          activeDays: 0,
                          totalTranslations: 0,
                          dailyActivities: [],
                        ),
                      );

                      // Convert daily activities to ContributionEntry
                      final entries = monthData.dailyActivities
                          .map((d) =>
                              ContributionEntry(d.date, d.totalTranslations))
                          .toList();

                      // min/max dates for this month
                      final minDate = DateTime(year, monthNumber, 1);
                      final maxDate = DateTime(
                        year,
                        monthNumber + 1,
                        1,
                      ).subtract(Duration(days: 1));

                      final totalTranslations =
                          entries.fold(0, (sum, e) => sum + e.count);
                      final activeDays = entries.length;

                      return Padding(
                        padding:
                            const EdgeInsets.only(right: AppDimens.cardBetween),
                        child: HeatmapCard(
                          minDate: minDate,
                          maxDate: maxDate,
                          totalTranslations: totalTranslations,
                          activeDays: activeDays,
                          cellSize: 20,
                          cellRadius: 2,
                          hideDetails: true,
                          entries: entries,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppDimens.sectionSpacing * 2),
              ],
            );
          },
        );
      },
    );
  }
}
