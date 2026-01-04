import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
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
        BlocBuilder<AnalyticsCubit, UserAnalyticsState>(
          builder: (context, state) {
            final isLoading =
                state.userAnalyticsStatus == UserAnalyticsRequestStatus.loading;
            final analytics = state.userAnalytics;

            final List<Map<String, String>> cardAnalytics = [
              {
                "label": "total_translations".tr(),
                "analytics":
                    isLoading ? "" : analytics!.totalTranslations.toString(),
                "iconName": "assets/icons/trophy_52.png",
              },
              {
                "label": "level".tr(),
                "analytics":
                    isLoading ? "" : analytics!.level.number.toString(),
                "iconName": "assets/icons/medal_94.png",
              },
              {
                "label": "my_library".tr(),
                "analytics":
                    isLoading ? "" : analytics!.totalLibraryWords.toString(),
                "iconName": "assets/icons/book.png",
              },
              {
                "label": "active_days".tr(),
                "analytics": isLoading ? "" : analytics!.activeDays.toString(),
                "iconName": "assets/icons/hot_sale.png",
              },
            ];
            // Loading
            if (state.userAnalyticsStatus ==
                UserAnalyticsRequestStatus.loading) {
              return MasonryGridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cardAnalytics.length,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getCrossAxisCount(),
                ),
                crossAxisSpacing: AppDimens.cardBetween,
                mainAxisSpacing: AppDimens.cardBetween,
                itemBuilder: (context, index) {
                  return AnalyticsCard(
                    iconName: cardAnalytics[index]["iconName"]!,
                    isLoading: true,
                    label: cardAnalytics[index]["label"]!,
                    analytics: "",
                  );
                },
              );
            }
            // Success
            if (state.userAnalyticsStatus ==
                UserAnalyticsRequestStatus.success) {
              return MasonryGridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cardAnalytics.length,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
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
                animation: "assets/animation/error_cat.json",
                title: 'analytics_error_title'.tr(),
                message: 'analytics_error_messages'.tr(),
                buttonText: 'try_again'.tr(),
                onTap: () {
                  context.read<AnalyticsCubit>().getAnalysis();
                },
              );
            }

            return Container();
          },
        ),
      ],
    );
  }
}
