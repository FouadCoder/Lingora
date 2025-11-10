import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/features/analytics/domain/entities/daily_activity_entity.dart';
import 'package:lingora/features/analytics/presentation/widgets/heatmap_card.dart';

class InsightsDetailsScreen extends StatelessWidget {
  final Map<int, Map<String, List<DailyActivityEntity>>>? entries;
  const InsightsDetailsScreen({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    int getCrossAxisCount() {
      if (AppPlatform.isDesktop(context)) return 3;
      if (AppPlatform.isTablet(context)) return 2;
      if (AppPlatform.isPhone(context)) return 1;
      return 1;
    }

    return Scaffold(
      appBar: AppBar(),
      body: AppContainer(
          child: SingleChildScrollView(
        child: Column(
          children: [
            MasonryGridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // so it fits inside scroll
              itemCount: 12,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getCrossAxisCount(),
              ),
              crossAxisSpacing: AppDimens.cardBetween,
              mainAxisSpacing: AppDimens.sectionSpacing,
              itemBuilder: (context, index) {
                final now = DateTime.now();
                final year = now.year;
                final month = index + 1;
                final minDate = DateTime(year, month, 1);
                final maxDate = DateTime(year, month + 1, 0);

                // Get month name, e.g., "Nov"
                final monthName = DateFormat.MMM().format(minDate);

                // Get entries for this year & month
                final monthEntries = entries?[year]?[monthName] ?? [];

                // Convert to ContributionEntry
                final contributions = monthEntries
                    .map((e) => ContributionEntry(e.date, e.totalTranslations))
                    .toList();
                return HeatmapCard(
                  minDate: minDate,
                  maxDate: maxDate,
                  totalTranslations: 0,
                  activeDays: 0,
                  cellSize: 50,
                  entries: contributions,
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
