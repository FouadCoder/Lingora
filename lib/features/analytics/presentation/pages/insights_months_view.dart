import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/features/analytics/domain/entities/month_activity_entity.dart';
import 'package:lingora/features/analytics/presentation/widgets/heatmap_card.dart';

class InsightsDetailsScreen extends StatelessWidget {
  final Map<int, List<MonthActivityEntity>>? monthlyActivity;
  const InsightsDetailsScreen({super.key, required this.monthlyActivity});

  @override
  Widget build(BuildContext context) {
    int getCrossAxisCount() {
      if (AppPlatform.isDesktop(context)) return 3;
      if (AppPlatform.isTablet(context)) return 2;
      if (AppPlatform.isPhone(context)) return 1;
      return 1;
    }

    // pick the latest year
    final latestYear = monthlyActivity!.keys.last;
    final List<MonthActivityEntity> months = monthlyActivity![latestYear]!;

    return Scaffold(
      appBar: AppBar(),
      body: AppContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MasonryGridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12, // always 12 months
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getCrossAxisCount(),
                ),
                crossAxisSpacing: AppDimens.cardBetween,
                mainAxisSpacing: AppDimens.sectionSpacing,
                itemBuilder: (context, index) {
                  final monthEntity = months[index];
                  final monthNumber = index + 1;

                  // min & max dates for heatmap
                  final minDate = DateTime(latestYear, monthNumber, 1);
                  final maxDate = DateTime(latestYear, monthNumber + 1, 1)
                      .subtract(const Duration(days: 1));

                  // Convert daily entries to ContributionEntry
                  final List<ContributionEntry> entries =
                      monthEntity.dailyActivities
                          .map((daily) => ContributionEntry(
                                daily.date,
                                daily.totalTranslations,
                              ))
                          .toList();

                  double screenWidth = MediaQuery.of(context).size.width;
                  double cellSize =
                      AppPlatform.isPhone(context) ? screenWidth / 15 : 40;

                  return HeatmapCard(
                    minDate: minDate,
                    maxDate: maxDate,
                    totalTranslations: monthEntity.totalTranslations,
                    activeDays: monthEntity.activeDays,
                    cellSize: cellSize,
                    entries: entries,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
