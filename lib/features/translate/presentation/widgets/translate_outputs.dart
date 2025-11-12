import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/header.dart';

// Word translated
class WordTranslatedCard extends StatelessWidget {
  final String translated;

  const WordTranslatedCard({super.key, required this.translated});

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
            Header(
              icon: MaterialCommunityIcons.translate,
              title: 'translated'.tr(),
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

  const WordInfoCard({
    super.key,
    required this.original,
    required this.pos,
    required this.pronunciation,
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
            // Header with icon
            Header(
              icon: Icons.book_outlined,
              title: 'word_info'.tr(),
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
          ],
        ),
      ),
    );
  }
}
