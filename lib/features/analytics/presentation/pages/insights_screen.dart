import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:lingora/features/analytics/presentation/widgets/analytic_widget.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/features/analytics/presentation/widgets/insights_heatmap_widget.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsCubit>().getDailyActivitySummary();
    context.read<AnalyticsCubit>().getAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppContainer(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview analytics
            AnalyticeWidget(),

            SizedBox(
              height: AppDimens.sectionSpacing,
            ),

            // Heatmap
            InsightsHeatmapWidget(),
          ],
        ),
      )),
    );
  }
}
