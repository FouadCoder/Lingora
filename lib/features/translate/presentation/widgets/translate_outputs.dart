import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/header.dart';
import 'package:lingora/core/widgets/icon_card.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/domain/enums/collection_enum.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:lingora/features/words/presentation/widgets/word_collections.dart';
import 'package:lingora/helper/direction_helper.dart';

// Word translated
class WordTranslatedCard extends StatelessWidget {
  final String translated;
  final String lang;

  const WordTranslatedCard({
    super.key,
    required this.translated,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return AppCard(
      child: Container(
        constraints: BoxConstraints(
          minHeight:
              AppPlatform.isDesktop(context) || AppPlatform.isTablet(context)
                  ? 200
                  : 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Header(
                  icon: HeroIcons.language,
                  title: 'translated'.tr(),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: AppDimens.buttonTagHorizontal,
                    ),
                    IconCard(
                      icon: HeroIcons.speakerWave,
                      onTap: () {
                        context.read<LibraryCubit>().playAudio(
                              translated,
                              lang,
                            );
                      },
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: AppDimens.sectionSpacing,
            ),
            // Translated words
            Text(
              translated,
              textAlign: isRightSide(lang) ? TextAlign.right : TextAlign.left,
              style: theme.titleMedium?.copyWith(
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Word Info card
class WordInfoCard extends StatelessWidget {
  final String original;
  final String pos;
  final String pronunciation;
  final WordEntity word;
  final String lang;
  final CollectionType collectionType;

  const WordInfoCard(
      {super.key,
      required this.original,
      required this.pos,
      required this.pronunciation,
      required this.word,
      required this.lang,
      required this.collectionType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Container(
      constraints: BoxConstraints(
        minHeight:
            AppPlatform.isDesktop(context) || AppPlatform.isTablet(context)
                ? 200
                : 100, // Minimum height
      ),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with play button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Header(
                  icon: HeroIcons.bookOpen,
                  title: 'word_info'.tr(),
                ),
                IconCard(
                  icon: HeroIcons.speakerWave,
                  onTap: () {
                    context.read<LibraryCubit>().playAudio(
                          original,
                          lang,
                        );
                  },
                ),
              ],
            ),

            SizedBox(
              height: AppDimens.sectionSpacing,
            ),

            // Original word
            Text(
              original,
              textAlign: isRightSide(lang) ? TextAlign.right : TextAlign.left,
              style: theme.bodyMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: AppDimens.elementBetween,
            ),

            // Part of Speech
            Text(
              pos,
              style: theme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),

            SizedBox(
              height: AppDimens.sectionSpacing,
            ),

            // Pronunciation
            Text(
              'pronunciation'.tr(),
              style: theme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),

            SizedBox(
              height: AppDimens.elementBetween,
            ),

            Text(
              pronunciation,
              style: theme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            // Word collections
            SizedBox(
              height: AppDimens.sectionSpacing,
            ),

            WordCollectionsWidget(
              word: word,
              collection: collectionType,
            )
          ],
        ),
      ),
    );
  }
}
