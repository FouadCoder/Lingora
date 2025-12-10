import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/header.dart';
import 'package:lingora/core/widgets/icon_card.dart';
import 'package:lingora/features/library/presentation/cubit/library_cubit.dart';
import 'package:lingora/features/library/presentation/widgets/word_collections.dart';

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
                  icon: MaterialCommunityIcons.translate,
                  title: 'translated'.tr(),
                ),
                Row(
                  children: [
                    // HeartIconWidget(
                    //   isFavorite: isFavorite,
                    //   wordId: wordId,
                    // ),
                    SizedBox(
                      width: AppDimens.buttonTagHorizontal,
                    ),
                    IconCard(icon: Icons.notifications),
                    SizedBox(
                      width: AppDimens.buttonTagHorizontal,
                    ),
                    IconCard(
                      icon: Icons.volume_up_outlined,
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
  final String? wordId;
  final String lang;

  const WordInfoCard({
    super.key,
    required this.original,
    required this.pos,
    required this.pronunciation,
    required this.wordId,
    required this.lang,
  });

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
                  icon: Icons.book_outlined,
                  title: 'word_info'.tr(),
                ),
                IconCard(
                  icon: Icons.volume_up_outlined,
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

            WordCollectionsWidget(wordId: wordId)
          ],
        ),
      ),
    );
  }
}
