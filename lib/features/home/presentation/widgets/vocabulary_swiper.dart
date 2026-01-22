import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/custom_status.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_state.dart';
import 'package:lingora/features/words/presentation/widgets/word_card.dart';
import 'package:lingora/features/words/presentation/widgets/word_card_loading.dart';

class VocabularySwiper extends StatefulWidget {
  const VocabularySwiper({super.key});

  @override
  State<VocabularySwiper> createState() => _VocabularySwiperState();
}

class _VocabularySwiperState extends State<VocabularySwiper> {
  final CardSwiperController cardSwiperController = CardSwiperController();
  Timer? timer;
  @override
  void initState() {
    super.initState();
    context.read<LibraryCubit>().getLibrary();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        cardSwiperController.swipe(CardSwiperDirection.left);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    cardSwiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget emptyWordsWidget = CustomState(
      animation: 'assets/animation/cat_sleeping.json',
      title: 'nothing_here'.tr(),
      message: 'nothing_here_message'.tr(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "your_vocabulary".tr(),
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: AppDimens.titleContentBetween,
        ),
        BlocBuilder<LibraryCubit, LibraryState>(builder: (context, state) {
          if (state.status == LibraryStatus.loading) {
            // Loading
            return SizedBox(
              height: min(MediaQuery.of(context).size.height * 0.35, 350),
              child: CardSwiper(
                padding: EdgeInsets.zero,
                cardBuilder:
                    (context, index, percentThresholdX, percentThresholdY) {
                  return LibraryLoadingCard();
                },
                cardsCount: 8,
              ),
            );
          }

          // Success
          else if (state.status == LibraryStatus.success) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                state.libraryWords.isEmpty || state.libraryWords.length < 3
                    ? emptyWordsWidget
                    : SizedBox(
                        height: 250,
                        child: CardSwiper(
                          controller: cardSwiperController,
                          padding: EdgeInsets.zero,
                          duration: const Duration(milliseconds: 400),
                          cardBuilder: (context, index, percentThresholdX,
                              percentThresholdY) {
                            return WordCard(
                              word: state.libraryWords[index],
                            );
                          },
                          cardsCount: state.libraryWords.length,
                        ),
                      )
              ],
            );
          } else if (state.status == LibraryStatus.networkError) {
            return CustomState(
              animation: 'assets/animation/cat_sleeping.json',
              title: 'you_are_offline'.tr(),
              message: 'you_are_offline_message'.tr(),
              buttonText: 'retry_connection'.tr(),
              color: Theme.of(context).colorScheme.surface,
            );
          }

          return Container();
        }),
      ],
    );
  }
}
