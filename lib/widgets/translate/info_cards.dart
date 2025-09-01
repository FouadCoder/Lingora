import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class InfoCards extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;

  const InfoCards({
    super.key,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    if (isDesktop) {
      // Desktop layout - horizontal cards
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildWordInfoCard(theme, context)),
          const SizedBox(width: 16),
          Expanded(child: _buildMeaningCard(theme, context)),
          const SizedBox(width: 16),
          Expanded(child: _buildExamplesCard(theme, context)),
        ],
      );
    } else if (isTablet) {
      // Tablet layout - 2x2 grid
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _buildWordInfoCard(theme, context)),
              const SizedBox(width: 16),
              Expanded(child: _buildMeaningCard(theme, context)),
            ],
          ),
          const SizedBox(height: 16),
          _buildExamplesCard(theme, context),
        ],
      );
    } else {
      // Mobile layout - vertical stack
      return Column(
        children: [
          _buildWordInfoCard(theme, context),
          const SizedBox(height: 16),
          _buildMeaningCard(theme, context),
          const SizedBox(height: 16),
          _buildExamplesCard(theme, context),
        ],
      );
    }
  }

  Widget _buildWordInfoCard(TextTheme theme, BuildContext context) {
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
          Row(
            children: [
              Icon(
                Icons.book_outlined,
                color: colorScheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'word_info'.tr(),
                style: theme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Word
          Text(
            "nice",
            style: theme.bodyMedium?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Part of Speech
          Text(
            "Adjective",
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
            "/latif - jayid/",
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
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'meaning'.tr(),
                style: theme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Definition
          Text(
            "Givingtractive Giving pleasure or satisfaction; pleasant or attractiveGiving pleasure or satisfaction; pleasant or attractive Giving pleasure or satisfaction; pleasant or attractiveg pleasure or satisfaction; pleasant or attractive",
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
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'examples'.tr(),
                style: theme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Example sentences
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExampleSentence(
                  theme, "That's a nice dress you're wearing."),
              const SizedBox(height: 8),
              _buildExampleSentence(theme, "She has a very nice personality."),
              _buildExampleSentence(
                  theme, "That's a nice dress you're wearing."),
              const SizedBox(height: 8),
              _buildExampleSentence(theme, "She has a very nice personality."),
              _buildExampleSentence(
                  theme, "That's a nice dress you're wearing."),
              const SizedBox(height: 8),
              _buildExampleSentence(theme, "She has a very nice personality."),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExampleSentence(TextTheme theme, String sentence) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 8, right: 12),
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            sentence,
            style: theme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
