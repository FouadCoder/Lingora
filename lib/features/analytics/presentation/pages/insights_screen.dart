import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/features/analytics/presentation/widgets/activity_heatmap.dart';
import 'package:lingora/features/analytics/presentation/widgets/analytic_widget.dart';
import 'package:lingora/core/widgets/app_container.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AppContainer(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview analytics
            AnalyticeWidget(),

            SizedBox(
              height: AppDimens.sectionBetween,
            ),

            // Year title
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
                    context.push('/nav/insights/details');
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
            Center(
              child: ActivityHeatmap(
                minDate: DateTime(2025, 1, 1),
                maxDate: DateTime(2025, 12, 0),
                entries: [
                  ContributionEntry(DateTime(2025, 8, 15), 1),
                  ContributionEntry(DateTime(2025, 8, 16), 2),
                  ContributionEntry(DateTime(2025, 8, 17), 5),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
