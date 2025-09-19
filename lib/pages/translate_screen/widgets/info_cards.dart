import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/helper/direction_helper.dart';
import 'package:lingora/pages/translate_screen/widgets/translate_header.dart';
import 'package:lingora/models/translate.dart';
import 'package:lingora/widgets/app_card.dart';

class InfoCards extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;
  final Translate model;

  const InfoCards({
    super.key,
    required this.isDesktop,
    required this.isTablet,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final hasTranslated = model.translated.trim().isNotEmpty;
    final hasWord = model.original.trim().isNotEmpty;
    final hasMeaning = model.meaning.trim().isNotEmpty;
    final hasExamples = model.examples.isNotEmpty;
    final hasSynonyms = model.synonyms.isNotEmpty;

    // For text
    bool isRightSideText = isRightSide(model.translateTo!.code);

    final List<Widget> availableCards = [
      if (hasTranslated) _buildTranslatedCard(theme, context, isRightSideText),
      if (hasWord) _buildWordInfoCard(theme, context),
      if (hasMeaning) _buildMeaningCard(theme, context, isRightSideText),
      if (hasSynonyms) _buildSynonymsCard(theme, context),
    ];

    int getCrossAxisCount() {
      if (AppPlatform.isDesktop(context)) {
        return availableCards.length; // desktop: all in one row
      }
      if (AppPlatform.isTablet(context)) return 2; // tablet
      return 1; // phone
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            MasonryGridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // so it fits inside scroll
              itemCount: availableCards.length,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getCrossAxisCount(),
              ),
              crossAxisSpacing: 16,
              mainAxisSpacing: 2,
              itemBuilder: (context, index) {
                return availableCards[index];
              },
            ),
            SizedBox(
              height: 2,
            ),
            // Examples
            if (hasExamples)
              _buildExamplesCard(theme, context, isRightSideText),
          ],
        );
      },
    );
  }

  Widget _buildTranslatedCard(
      TextTheme theme, BuildContext context, bool isRightSide) {
    return AppCard(
      child: Container(
        constraints: BoxConstraints(
          minHeight: isDesktop || isTablet ? 200 : 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TranslatHeader(
              icon: MaterialCommunityIcons.translate,
              title: 'translated'.tr(),
            ),
            Align(
              alignment: isRightSide
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              child: Text(
                model.translated,
                style: theme.titleMedium?.copyWith(
                  height: 1.4,
                ),
                textAlign: isRightSide ? TextAlign.right : TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordInfoCard(TextTheme theme, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        minHeight: isDesktop || isTablet ? 200 : 100, // Minimum height
      ),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            TranslatHeader(
              icon: Icons.book_outlined,
              title: 'word_info'.tr(),
            ),

            // Original word
            Text(
              model.original,
              style: theme.bodyMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Part of Speech
            Text(
              model.pos,
              style: theme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),

            const SizedBox(height: 12),

            // Pronunciation
            Text(
              'pronunciation'.tr(),
              style: theme.bodySmall?.copyWith(
                color: colorScheme.outline,
              ),
            ),

            const SizedBox(height: 4),

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

  Widget _buildMeaningCard(
      TextTheme theme, BuildContext context, bool isRightSide) {
    return Container(
      constraints: BoxConstraints(
        minHeight: isDesktop || isTablet ? 200 : 100, // Minimum height
      ),
      child: AppCard(
        child: Column(
          children: [
            // Header with icon
            TranslatHeader(
              icon: Icons.lightbulb_outline,
              title: 'meaning'.tr(),
            ),

            // Definition
            Align(
              alignment: isRightSide
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              child: Text(
                model.meaning,
                style: theme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
                textAlign: isRightSide ? TextAlign.right : TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamplesCard(
      TextTheme theme, BuildContext context, bool isRightSide) {
    return Container(
      constraints: BoxConstraints(
        minHeight: isDesktop || isTablet ? 150 : 150, // Minimum height
      ),
      child: AppCard(
        child: Column(
          children: [
            // Header with icon
            TranslatHeader(
              icon: Icons.format_quote,
              title: 'examples'.tr(),
            ),

            // Example sentences
            Wrap(
              spacing: 4, // horizontal gap between items
              runSpacing: 4, // vertical gap between rows
              alignment: isRightSide ? WrapAlignment.end : WrapAlignment.start,
              children: model.examples.map((example) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text(
                    example,
                    style: theme.bodySmall,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSynonymsCard(TextTheme theme, BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: isDesktop || isTablet ? 200 : 150,
      ),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            TranslatHeader(
              icon: MaterialCommunityIcons.cards,
              title: 'synonyms'.tr(),
            ),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: model.synonyms
                  .map((word) => _synonymChip(word, context))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _synonymChip(String word, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        word,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
