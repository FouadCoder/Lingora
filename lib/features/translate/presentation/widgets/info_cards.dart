import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/features/translate/domain/entities/translate_entity.dart';
import 'package:lingora/features/translate/presentation/widgets/translate_outputs.dart';
import 'package:lingora/core/widgets/examples_widget.dart';
import 'package:lingora/core/widgets/synonyms_widget.dart';
import 'package:lingora/core/widgets/meaning_widget.dart';

class InfoCards extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;
  final TranslateEntity model;

  const InfoCards({
    super.key,
    required this.isDesktop,
    required this.isTablet,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    // final hasWordInfo = model.original.trim().isNotEmpty;
    final hasTranslated = model.translated.trim().isNotEmpty;
    final hasMeaning = model.meaning.trim().isNotEmpty;
    final hasExamples = model.examples.isNotEmpty;
    final hasSynonyms = model.synonyms.isNotEmpty;

    final List<Widget> availableCards = [
      if (hasTranslated)
        WordTranslatedCard(
          translated: model.translated,
          lang: model.translateTo!.code,
        ),

      // Meaning
      if (hasMeaning)
        MeaningWidget(
          meaning: model.meaning,
          languageCode: model.translateTo!.code,
        ),

      // Synonyms
      if (hasSynonyms)
        SynonymsWidget(
          synonyms: model.synonyms,
        ),
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
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // so it fits inside scroll
              itemCount: availableCards.length,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getCrossAxisCount(),
              ),
              crossAxisSpacing: AppDimens.cardBetween,
              mainAxisSpacing: AppDimens.cardBetween,
              itemBuilder: (context, index) {
                return availableCards[index];
              },
            ),
            if (hasExamples)
              SizedBox(
                height: AppDimens.cardBetween,
              ),
            // Examples
            if (hasExamples)
              ExamplesWidget(
                examples: model.examples,
                languageCode: model.translateFrom!.code,
              ),
          ],
        );
      },
    );
  }
}
