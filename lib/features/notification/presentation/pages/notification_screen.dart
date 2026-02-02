import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/extensions/datetime_style.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_status.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/status/network_error_status.dart';
import 'package:lingora/features/notification/presentation/cubit/notifications/notification_cubit.dart';
import 'package:lingora/features/notification/presentation/cubit/notifications/notification_state.dart';
import 'package:lingora/features/notification/presentation/widgets/notification_card.dart';
import 'package:lingora/features/notification/presentation/widgets/notification_icons.dart';
import 'package:lingora/features/notification/presentation/widgets/notification_loading_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().getNotifications();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 600) {
        context.read<NotificationCubit>().loadMoreNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AppContainer(
        child: BlocConsumer<NotificationCubit, NotificationState>(
          listener: (context, state) {
            // Error
            if (state.status == NotificationStatus.error) {
              showSnackBar(
                context,
                message: 'notifications_error_title'.tr(),
                icon: HeroIcons.exclamationTriangle,
                iconColor: Theme.of(context).colorScheme.error,
              );
            }
            // Network Error
            else if (state.status == NotificationStatus.networkError) {
              showErrorNetworkSnackBar(context);
            }
            // Refresh Limit Exceeded
            else if (state.actionNotificationStatus ==
                NotificationStatus.limitExceeded) {
              showSnackBar(
                context,
                message: 'refresh_limit_reached'.tr(),
                icon: HeroIcons.clock,
                iconColor: Theme.of(context).colorScheme.primary,
              );
            }
          },
          builder: (context, state) {
            return BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                // Loading
                if (state.status == NotificationStatus.loading) {
                  return MasonryGridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 10,
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: AppPlatform.isPhone(context) ? 1 : 2,
                    ),
                    crossAxisSpacing: AppDimens.cardBetween,
                    mainAxisSpacing: AppDimens.cardBetween,
                    itemBuilder: (context, index) {
                      return NotificationLoadingCard();
                    },
                  );
                }
                // Success
                else if (state.status == NotificationStatus.success) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.radiusL),
                    child: LiquidPullToRefresh(
                      onRefresh: () => context
                          .read<NotificationCubit>()
                          .refreshNotifications(),
                      backgroundColor: Colors.black,
                      color: Theme.of(context).colorScheme.primary,
                      showChildOpacityTransition: false,
                      height: 100,
                      springAnimationDurationInMilliseconds: 500,
                      child: Container(
                        margin: EdgeInsets.only(top: AppDimens.paddingS),
                        child: MasonryGridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          itemCount: state.isLoadingMore
                              ? state.notifications.length + 6
                              : state.notifications.length,
                          gridDelegate:
                              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                AppPlatform.isPhone(context) ? 1 : 2,
                          ),
                          crossAxisSpacing: AppDimens.cardBetween,
                          mainAxisSpacing: AppDimens.cardBetween,
                          itemBuilder: (context, index) {
                            if (index < state.notifications.length) {
                              final notification = state.notifications[index];
                              return NotificationCard(
                                title: notification.title,
                                message: notification.message,
                                date: notification.createdAt.toSmartTimeAgo(),
                                icon: NotificationIconConfig.getByKeyword(
                                  notification.iconKeyword!,
                                ).icon,
                                iconColor: NotificationIconConfig.getByKeyword(
                                  notification.iconKeyword!,
                                ).color,
                              );
                            }
                            return NotificationLoadingCard();
                          },
                        ),
                      ),
                    ),
                  );
                }
                // Empty
                else if (state.status == NotificationStatus.empty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: CustomState(
                      color: Theme.of(context).colorScheme.secondary,
                      animation: "assets/animation/sleep_cat_alarm.json",
                      title: 'no_notifications_title'.tr(),
                      message: 'no_notifications_message'.tr(),
                      titleColor: Theme.of(context).colorScheme.secondary,
                    ),
                  );
                }
                // Network Error
                else if (state.status == NotificationStatus.networkError) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: NetworkErrorView(
                      onTap: () {
                        context.read<NotificationCubit>().getNotifications();
                      },
                    ),
                  );
                }
                // Error
                else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: CustomState(
                      textColor: Colors.white,
                      color: Theme.of(context).colorScheme.primary,
                      animation: "assets/animation/error_boat_orange.json",
                      title: 'notifications_error_title'.tr(),
                      message: 'notifications_error_message'.tr(),
                      buttonText: 'retry'.tr(),
                      onTap: () {
                        context.read<NotificationCubit>().getNotifications();
                      },
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
