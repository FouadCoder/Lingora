import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bidi_text/bidi_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/extensions/string_extension.dart';
import 'package:lingora/helper/direction_helper.dart';
import 'package:lingora/models/translate.dart';
import 'package:lingora/widgets/app_card.dart';
import 'package:lingora/widgets/app_container.dart';
import 'package:lingora/widgets/custom_status.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AppContainer(
          child: Column(
        children: [
          BlocBuilder<HistoryCubit, FetchHistoryState>(
              builder: (context, state) {
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
              Map history = state.history;

              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final entry = history.entries.elementAt(index);
                      final dateKey = entry.key; // The date string
                      final List<Translate> translations =
                          List<Translate>.from(entry.value); //  List<Translate>
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Headline
                          Text(
                            "$dateKey".toReadableDate(),
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
                                itemCount: translations.length,
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
                                        translations[index].original,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),

                                      SizedBox(
                                        height: AppDimens.subElementBetween,
                                      ),

                                      // Translate
                                      BidiText(
                                        translations[index].translated,
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
                    message: 'emptyHistoryMessage'.tr()),
              );
            }

            // Error
            else if (state.status == FetchHistoryStatus.failure) {
              return CustomState(
                textColor: Colors.white,
                color: Theme.of(context).colorScheme.secondary,
                animation: "assets/animation/error_boat_orange.json",
                title: 'error_words_title'.tr(),
                message: 'error_words_message'.tr(),
                buttonText: 'try_again'.tr(),
                onTap: () {
                  if (mounted) {
                    context.read<HistoryCubit>().fetchHistory();
                  }
                },
              );
            }

            return Container();
          })
        ],
      )),
    );
  }
}
