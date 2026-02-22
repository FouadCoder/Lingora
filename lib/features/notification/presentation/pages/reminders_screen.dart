import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_status.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/status/network_error_status.dart';
import 'package:lingora/features/notification/presentation/cubit/reminders/reminder_cubit.dart';
import 'package:lingora/features/notification/presentation/cubit/reminders/reminder_state.dart';
import 'package:lingora/features/notification/presentation/widgets/reminder_loading_card.dart';
import 'package:lingora/features/notification/presentation/widgets/reminder_widget.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<ReminderCubit>().getReminders();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 600) {
        context.read<ReminderCubit>().loadMoreReminders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AppContainer(
        child: BlocConsumer<ReminderCubit, ReminderState>(
          listener: (context, state) {
            // Error
            if (state.status == ReminderStatus.error) {
              showSnackBar(
                context,
                message: 'reminders_error_title'.tr(),
                icon: HeroIcons.exclamationTriangle,
                iconColor: Theme.of(context).colorScheme.error,
              );
            }
            // Network Error
            else if (state.status == ReminderStatus.networkError ||
                state.actionStatus == ReminderStatus.networkError) {
              showErrorNetworkSnackBar(context);
            }
            // Refresh Limit Exceeded
            else if (state.actionStatus == ReminderStatus.limitExceeded) {
              showSnackBar(
                context,
                title: 'refresh_limit_reached_title'.tr(),
                message: 'refresh_wait'
                    .tr(namedArgs: {'minutes': state.minutesLeft.toString()}),
                icon: HeroIcons.clock,
                iconColor: Colors.yellow,
              );
            }
            // Reminder removed success
            else if (state.actionStatus == ReminderStatus.removed) {
              context.read<LibraryCubit>().refreshWord(
                  wordId: state.wordId!, activeReminder: false, reminder: null);
              showSnackBar(
                context,
                message: 'reminder_removed_success'.tr(),
                icon: HeroIcons.checkCircle,
                iconColor: Colors.green,
              );
            }
          },
          builder: (context, state) {
            return BlocBuilder<ReminderCubit, ReminderState>(
              builder: (context, state) {
                // Loading
                if (state.status == ReminderStatus.loading) {
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
                      return ReminderLoadingCard();
                    },
                  );
                }
                // Success
                else if (state.status == ReminderStatus.success) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.radiusL),
                    child: LiquidPullToRefresh(
                      onRefresh: () =>
                          context.read<ReminderCubit>().refreshReminders(),
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
                              ? state.reminders.length + 6
                              : state.reminders.length,
                          gridDelegate:
                              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                AppPlatform.isPhone(context) ? 1 : 2,
                          ),
                          crossAxisSpacing: AppDimens.cardBetween,
                          mainAxisSpacing: AppDimens.cardBetween,
                          itemBuilder: (context, index) {
                            if (index < state.reminders.length) {
                              final reminder = state.reminders[index];
                              bool isLoading = state.actionStatus ==
                                      ReminderStatus.loading &&
                                  state.reminders[index].id ==
                                      state.reminderIdToRemove;

                              return ReminderWidget(
                                translate: reminder.translated,
                                original: reminder.original,
                                isActive: reminder.isActive,
                                isLoading: isLoading,
                                onChanged: (bool isActive) {
                                  context
                                      .read<ReminderCubit>()
                                      .unactiveReminder(
                                          reminder.id, reminder.wordId);
                                },
                              );
                            }
                            return ReminderLoadingCard();
                          },
                        ),
                      ),
                    ),
                  );
                }
                // Empty
                else if (state.status == ReminderStatus.empty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: CustomState(
                      color: Theme.of(context).colorScheme.primary,
                      animation: "assets/animation/sleep_cat_alarm.json",
                      title: 'no_reminders_title'.tr(),
                      message: 'no_reminders_message'.tr(),
                      buttonText: 'go_to_library'.tr(),
                      onTap: () => context.push('/library'),
                      titleColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }
                // Network Error
                else if (state.status == ReminderStatus.networkError) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: NetworkErrorView(
                      onTap: () {
                        context.read<ReminderCubit>().getReminders();
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
                      title: 'reminders_error_title'.tr(),
                      message: 'reminders_error_message'.tr(),
                      buttonText: 'try_again'.tr(),
                      onTap: () {
                        context.read<ReminderCubit>().getReminders();
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
