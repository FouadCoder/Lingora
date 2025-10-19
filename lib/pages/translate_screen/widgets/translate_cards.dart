import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/helper/direction_helper.dart';
import 'package:lingora/models/translate.dart';
import 'package:lingora/pages/translate_screen/widgets/collections.dart';
import 'package:lingora/widgets/app_card.dart';
import 'package:lingora/widgets/header.dart';

// Word translated
class WordTranslatedCard extends StatelessWidget {
  final Translate model;
  const WordTranslatedCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    bool isRightSideText = isRightSide(model.translateTo!.code);

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
            Align(
              alignment: isRightSideText
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              child: Text(
                model.translated,
                style: theme.titleMedium?.copyWith(
                  height: 1.4,
                ),
                textAlign: isRightSideText ? TextAlign.right : TextAlign.left,
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
  final Translate model;
  const WordInfoCard({super.key, required this.model});

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
              model.original,
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
              model.pos,
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
              model.pronunciation,
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
