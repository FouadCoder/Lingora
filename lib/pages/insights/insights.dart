import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/pages/insights/widgets/activity_heatmap.dart';
import 'package:lingora/pages/insights/widgets/analytics_card.dart';
import 'package:lingora/widgets/app_container.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  Widget build(BuildContext context) {
    int getCrossAxisCount() {
      if (AppPlatform.isDesktop(context)) return 4;
      if (AppPlatform.isTablet(context)) return 2;
      if (AppPlatform.isPhone(context)) return 2;
      return 1;
    }

    List cardAnalytics = [
      {
        "label": "total_translations".tr(),
        "analytics": "100",
        "iconName": "assets/icons/trophy_52.png",
      },
      {
        "label": "top_language".tr(),
        "analytics": "English",
        "iconName": "assets/icons/flag.png",
      },
      {
        "label": "my_library".tr(),
        "analytics": "10",
        "iconName": "assets/icons/book.png",
      },
      {
        "label": "active_days".tr(),
        "analytics": "10",
        "iconName": "assets/icons/hot_sale.png",
      },
    ];

    return Scaffold(
      appBar: AppBar(),
      body: AppContainer(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview
            Text(
              "overview".tr(),
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: AppDimens.titleContentBetween,
            ),
            // Cards
            MasonryGridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getCrossAxisCount(),
              ),
              crossAxisSpacing: AppDimens.cardBetween,
              mainAxisSpacing: AppDimens.cardBetween,
              itemBuilder: (context, index) {
                return AnalyticsCard(
                    label: cardAnalytics[index]["label"],
                    analytics: cardAnalytics[index]["analytics"],
                    iconName: cardAnalytics[index]["iconName"]);
              },
            ),

            SizedBox(
              height: AppDimens.sectionBetween,
            ),

            Align(
              alignment: Alignment.center,
              child: Text(
                "activity".tr(),
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: AppDimens.titleContentBetween,
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
