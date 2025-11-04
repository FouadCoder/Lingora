import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/pages/library_screen/widgets/library_card.dart';
import 'package:lingora/pages/library_screen/widgets/library_loading_card.dart';

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
    context.read<FetchTranslatedLibraryCubit>().getLibrary();
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
        BlocBuilder<FetchTranslatedLibraryCubit, FetchTranslatedLibraryState>(
            builder: (context, state) {
          if (state.status == FetchTranslatedLibraryStatus.loading) {
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
          else if (state.status == FetchTranslatedLibraryStatus.success) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: min(MediaQuery.of(context).size.height * 0.35, 350),
                  child: CardSwiper(
                    controller: cardSwiperController,
                    padding: EdgeInsets.zero,
                    duration: const Duration(milliseconds: 400),
                    cardBuilder:
                        (context, index, percentThresholdX, percentThresholdY) {
                      return WordCard(word: state.libraryWords[index]);
                    },
                    cardsCount: state.libraryWords.length,
                  ),
                )
              ],
            );
          }

          return Container();
        }),
      ],
    );
  }
}
