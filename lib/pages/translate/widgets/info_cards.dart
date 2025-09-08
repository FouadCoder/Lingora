import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lingora/pages/translate/widgets/translate_header.dart';
import 'package:lingora/models/translate.dart';

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

    // Build the cards in display order, including only sections that have data.
    // This keeps the UI clean by omitting empty sections entirely.
    final List<Widget> availableCards = [
      if (hasTranslated) _buildTranslatedCard(theme, context),
      if (hasWord) _buildWordInfoCard(theme, context),
      if (hasMeaning) _buildMeaningCard(theme, context),
      if (hasExamples) _buildExamplesCard(theme, context),
      if (hasSynonyms) _buildSynonymsCard(theme, context),
    ];

    // Render non-empty cards responsively:
    // Desktop (width > 1000): horizontal row with equal-width cards and 16px gaps.
    // Tablet (600 < width ≤ 1000) & Phone (≤ 600): vertical stack with 16px gaps.
    if (isDesktop) {
      // Desktop layout (width > 1000)
      // Build equal-width row children and insert 16px gaps between cards.
      final List<Widget> rowChildren = [];
      for (final card in availableCards) {
        if (rowChildren.isNotEmpty) {
          rowChildren.add(const SizedBox(width: 16));
        }
        rowChildren.add(Expanded(child: card));
      }
      // Center the row and align items to the top so headers line up nicely.
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren,
      );
    } else {
      // Tablet & Phone layout (≤ 1000):
      // - If isTablet is true, it's a Tablet (600 < width ≤ 1000)
      // - Otherwise it's a Phone (width ≤ 600)
      // Stack cards vertically and insert a 16px gap before each card except the first.
      final List<Widget> columnChildren = [];
      for (final card in availableCards) {
        if (columnChildren.isNotEmpty) {
          columnChildren.add(const SizedBox(height: 16));
        }
        columnChildren.add(card);
      }
      return Column(children: columnChildren);
    }
  }

  Widget _buildTranslatedCard(TextTheme theme, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        minHeight: isDesktop || isTablet ? 200 : 100,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatHeader(
            icon: MaterialCommunityIcons.translate,
            title: 'translated'.tr(),
          ),
          const SizedBox(height: 16),
          Text(
            model.translated,
            style: theme.titleMedium?.copyWith(
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordInfoCard(TextTheme theme, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        minHeight: isDesktop || isTablet ? 200 : 100, // Minimum height
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          TranslatHeader(
            icon: Icons.book_outlined,
            title: 'word_info'.tr(),
          ),

          const SizedBox(height: 16),

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
    );
  }

  Widget _buildMeaningCard(TextTheme theme, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        minHeight: isDesktop || isTablet ? 200 : 100, // Minimum height
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          TranslatHeader(
            icon: Icons.lightbulb_outline,
            title: 'meaning'.tr(),
          ),

          const SizedBox(height: 16),

          // Definition
          Text(
            model.meaning,
            style: theme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamplesCard(TextTheme theme, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        minHeight: isDesktop || isTablet ? 200 : 150, // Minimum height
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          TranslatHeader(
            icon: Icons.format_quote,
            title: 'examples'.tr(),
          ),

          const SizedBox(height: 16),

          // Example sentences
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: model.examples.map((example) {
              return Container(
                padding: const EdgeInsets.all(12),
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
    );
  }

  Widget _buildSynonymsCard(TextTheme theme, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: BoxConstraints(
        minHeight: isDesktop || isTablet ? 200 : 150,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          TranslatHeader(
            icon: MaterialCommunityIcons.cards,
            title: 'synonyms'.tr(),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: model.synonyms
                .map((word) => _synonymChip(word, context))
                .toList(),
          ),
        ],
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
