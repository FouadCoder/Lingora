import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/status/network_error_status.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:lingora/features/analytics/presentation/cubit/analytics_state.dart';
import 'package:lingora/features/analytics/presentation/widgets/analytics_card.dart';
import 'package:lingora/core/widgets/custom_status.dart';

class AnalyticeWidget extends StatefulWidget {
  const AnalyticeWidget({super.key});

  @override
  State<AnalyticeWidget> createState() => _AnalyticeWidgetState();
}

class _AnalyticeWidgetState extends State<AnalyticeWidget> {
  int getCrossAxisCount() {
    if (AppPlatform.isDesktop(context)) return 4;
    if (AppPlatform.isTablet(context)) return 2;
    if (AppPlatform.isPhone(context)) return 2;
    return 1;
  }

  final List<Map<String, String>> loadingCardAnalytics = [
    {
      "label": "total_translations".tr(),
      "iconName": "assets/icons/trophy_52.png",
    },
    {
      "label": "level".tr(),
      "iconName": "assets/icons/medal_94.png",
    },
    {
      "label": "my_library".tr(),
      "iconName": "assets/icons/book.png",
    },
    {
      "label": "active_days".tr(),
      "iconName": "assets/icons/hot_sale.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "overview".tr(),
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: AppDimens.titleContentBetween,
        ),
        BlocConsumer<AnalyticsCubit, UserAnalyticsState>(
          listener: (context, state) {
            if (state.userAnalyticsStatus ==
                UserAnalyticsRequestStatus.networkError) {
              showErrorNetworkSnackBar(context);
            }
          },
          builder: (context, state) {
            return BlocBuilder<AnalyticsCubit, UserAnalyticsState>(
              builder: (context, state) {
                // Loading
                if (state.userAnalyticsStatus ==
                    UserAnalyticsRequestStatus.loading) {
                  return MasonryGridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: loadingCardAnalytics.length,
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getCrossAxisCount(),
                    ),
                    crossAxisSpacing: AppDimens.cardBetween,
                    mainAxisSpacing: AppDimens.cardBetween,
                    itemBuilder: (context, index) {
                      return AnalyticsCard(
                        iconName: loadingCardAnalytics[index]["iconName"]!,
                        isLoading: true,
                        label: loadingCardAnalytics[index]["label"]!,
                        analytics: "",
                      );
                    },
                  );
                }
                // Success
                if (state.userAnalyticsStatus ==
                    UserAnalyticsRequestStatus.success) {
                  final analytics = state.userAnalytics;

                  final List<Map<String, String>> cardAnalytics = [
                    {
                      "label": "total_translations".tr(),
                      "analytics": analytics!.totalTranslations.toString(),
                      "iconName": "assets/icons/trophy_52.png",
                    },
                    {
                      "label": "level".tr(),
                      "analytics": analytics.level.number.toString(),
                      "iconName": "assets/icons/medal_94.png",
                    },
                    {
                      "label": "my_library".tr(),
                      "analytics": analytics.totalLibraryWords.toString(),
                      "iconName": "assets/icons/book.png",
                    },
                    {
                      "label": "active_days".tr(),
                      "analytics": analytics.activeDays.toString(),
                      "iconName": "assets/icons/hot_sale.png",
                    },
                  ];
                  return MasonryGridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cardAnalytics.length,
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getCrossAxisCount(),
                    ),
                    crossAxisSpacing: AppDimens.cardBetween,
                    mainAxisSpacing: AppDimens.cardBetween,
                    itemBuilder: (context, index) {
                      return AnalyticsCard(
                        label: cardAnalytics[index]["label"]!,
                        analytics: cardAnalytics[index]["analytics"]!,
                        iconName: cardAnalytics[index]["iconName"]!,
                        isLoading: false,
                      );
                    },
                  );
                }

                // Error
                if (state.userAnalyticsStatus ==
                    UserAnalyticsRequestStatus.failure) {
                  return CustomState(
                    textColor: Colors.white,
                    color: Theme.of(context).colorScheme.primary,
                    animation: "assets/animation/error_boat_orange.json",
                    title: 'analytics_error_title'.tr(),
                    message: 'analytics_error_messages'.tr(),
                    buttonText: 'try_again'.tr(),
                    onTap: () {
                      context.read<AnalyticsCubit>().getAnalysis();
                    },
                  );
                }

                // Network Error
                else if (state.userAnalyticsStatus ==
                    UserAnalyticsRequestStatus.networkError) {
                  return NetworkErrorView(onTap: () {
                    Future.wait({
                      context.read<AnalyticsCubit>().getAnalysis(),
                      context.read<AnalyticsCubit>().getDailyActivitySummary(),
                    });
                  });
                }

                return Container();
              },
            );
          },
        ),
      ],
    );
  }
}
