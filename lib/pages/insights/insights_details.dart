import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/extensions/datetime_style.dart';
import 'package:lingora/pages/insights/widgets/activity_heatmap.dart';
import 'package:lingora/core/widgets/app_container.dart';

class InsightsDetailsScreen extends StatelessWidget {
  const InsightsDetailsScreen({super.key});

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
                DateTime now = DateTime.now();
                DateTime minDate = DateTime(now.year, index + 1, 1);
                DateTime maxDate = DateTime(now.year, index + 2, 0);
                return Column(
                  children: [
                    // Month name
                    Text(
                      minDate.toMonthName(),
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: AppDimens.sectionSpacing,
                    ),
                    // Activity
                    Center(
                      child: ActivityHeatmap(
                          minDate: minDate,
                          maxDate: maxDate,
                          cellSize: 50,
                          splittedMonthView: true,
                          showMonthLabels: false,
                          showWeekdayLabels: false,
                          entries: [
                            ContributionEntry(DateTime(2025, 8, 15), 1),
                            ContributionEntry(DateTime(2025, 8, 16), 2),
                            ContributionEntry(DateTime(2025, 8, 17), 5),
                          ]),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
