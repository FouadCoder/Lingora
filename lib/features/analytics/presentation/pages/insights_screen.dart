import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_state.dart';
import 'package:lingora/features/analytics/presentation/widgets/analytic_widget.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/features/analytics/presentation/widgets/heatmap_card.dart';

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

            // Heatmap
            BlocBuilder<AnalyticsCubit, UserAnalyticsState>(
              builder: (context, state) {
                // Loading
                if (state.dailyActivityStatus ==
                    UserAnalyticsRequestStatus.loading) {
                  return Container();
                }

                // Success
                if (state.dailyActivityStatus ==
                    UserAnalyticsRequestStatus.success) {
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
                      SizedBox(
                        height: 270,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 12,
                          itemBuilder: (context, index) {
                            DateTime now = DateTime.now();
                            DateTime minDate = DateTime(now.year, index + 1, 1);
                            DateTime maxDate = DateTime(now.year, index + 2, 0);
                            return Padding(
                              padding:
                                  EdgeInsets.only(right: AppDimens.cardBetween),
                              child: HeatmapCard(
                                minDate: minDate,
                                maxDate: maxDate,
                                totalTranslations: 0,
                                activeDays: 0,
                                cellSize: 20,
                                cellRadius: 2,
                                hideDetails: true,
                                entries: state.dailyActivity!
                                    .map((element) => ContributionEntry(
                                        element.date,
                                        element.totalTranslations))
                                    .toList(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                // Error
                if (state.dailyActivityStatus ==
                    UserAnalyticsRequestStatus.failure) {
                  return Container();
                }
                return Container();
              },
            ),
          ],
        ),
      )),
    );
  }
}
