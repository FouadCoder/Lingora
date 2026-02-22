import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/header.dart';

class SynonymsWidget extends StatelessWidget {
  final List<String> synonyms;

  const SynonymsWidget({
    super.key,
    required this.synonyms,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Header(
            icon: HeroIcons.rectangleStack,
            title: 'synonyms'.tr(),
          ),
          SizedBox(
            height: AppDimens.sectionSpacing,
          ),
          Wrap(
            spacing: AppDimens.buttonTagHorizontal,
            runSpacing: AppDimens.buttonTagHorizontal,
            children:
                synonyms.map((word) => _synonymChip(word, context)).toList(),
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
          color: colorScheme.onSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .outline
                  .withValues(alpha: 0.1))),
      child: Text(
        word,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
      ),
    );
  }
}
