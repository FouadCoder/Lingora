import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bidi_text/bidi_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/extensions/string_extension.dart';
import 'package:lingora/features/history/domain/entities/history_entity.dart';
import 'package:lingora/features/history/presentation/cubit/history_cubit.dart';
import 'package:lingora/features/history/presentation/cubit/history_state.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_status.dart';
import 'package:lingora/core/widgets/status/network_error_status.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().fetchHistory();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 600) {
        context.read<HistoryCubit>().loadMoreHistory();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AppContainer(
          child: Column(
        children: [
          BlocConsumer<HistoryCubit, FetchHistoryState>(
              listener: (context, state) {
            // Network Error
            if (state.status == FetchHistoryStatus.networkError) {
              showErrorNetworkSnackBar(context);
            }
          }, builder: (context, state) {
            // Loading
            if (state.status == FetchHistoryStatus.loading) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: CustomState(
                  animation: "assets/animation/loading_star.json",
                  title: "",
                  message: "loading_History".tr(),
                ),
              );
            }
            // Success
            else if (state.status == FetchHistoryStatus.success) {
              Map<String, List<HistoryEntity>> history = state.history;

              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final entry = history.entries.elementAt(index);
                      final dateKey = entry.key; // The date string
                      final List<HistoryEntity> historyList = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Headline
                          Text(
                            dateKey.toReadableDate(),
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),

                          // List of cards
                          SizedBox(
                            height: AppDimens.titleContentBetween,
                          ),
                          AppCard(
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: historyList.length,
                                separatorBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: AppDimens.sectionSpacing,
                                      ),
                                      Divider(
                                        height: 0.5,
                                        thickness: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                      SizedBox(
                                        height: AppDimens.sectionSpacing,
                                      )
                                    ],
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // original
                                      BidiText(
                                        historyList.elementAt(index).original,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),

                                      SizedBox(
                                        height: AppDimens.subElementBetween,
                                      ),

                                      // Translate
                                      BidiText(
                                        historyList.elementAt(index).translated,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.color),
                                      )
                                    ],
                                  );
                                }),
                          ),
                          SizedBox(
                            height: AppDimens.sectionBetween,
                          ),
                        ],
                      );
                    }),
              );
            }

            // Empty
            else if (state.status == FetchHistoryStatus.empty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: CustomState(
                  animation: "assets/animation/empty_box_character.json",
                  title: 'emptyHistoryTitle'.tr(),
                  message: 'emptyHistoryMessage'.tr(),
                  titleColor: Theme.of(context).colorScheme.primary,
                ),
              );
            }

            // Network Error
            else if (state.status == FetchHistoryStatus.networkError) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: NetworkErrorView(
                  onTap: () {
                    context.read<HistoryCubit>().fetchHistory();
                  },
                ),
              );
            }

            // Error
            else if (state.status == FetchHistoryStatus.failure) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: CustomState(
                  buttonTextColor: Colors.white,
                  color: Theme.of(context).colorScheme.primary,
                  animation: "assets/animation/error_boat_orange.json",
                  title: 'error_words_title'.tr(),
                  message: 'error_words_message'.tr(),
                  buttonText: 'try_again'.tr(),
                  onTap: () {
                    if (mounted) {
                      context.read<HistoryCubit>().fetchHistory();
                    }
                  },
                ),
              );
            }

            return Container();
          })
        ],
      )),
    );
  }
}
