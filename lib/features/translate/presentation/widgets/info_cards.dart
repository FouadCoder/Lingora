import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/words/translated_widget.dart';
import 'package:lingora/core/widgets/words/word_info_widget.dart';
import 'package:lingora/features/translate/domain/entities/translate_entity.dart';
import 'package:lingora/core/widgets/words/examples_widget.dart';
import 'package:lingora/core/widgets/words/synonyms_widget.dart';
import 'package:lingora/core/widgets/words/meaning_widget.dart';
import 'package:lingora/features/words/domain/enums/collection_enum.dart';

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
    final hasWordInfo = model.original.trim().isNotEmpty &&
        model.pronunciation.trim().isNotEmpty;
    final hasTranslated = model.translated.trim().isNotEmpty;
    final hasMeaning = model.meaning.trim().isNotEmpty;
    final hasExamples = model.examples.isNotEmpty;
    final hasSynonyms = model.synonyms.isNotEmpty;

    // If no word info, only show translated card
    if (!hasWordInfo && hasTranslated) {
      return WordTranslatedCard(
        translated: model.translated,
        lang: model.translateTo!.code,
      );
    }

    // If no word info and no translation, return empty
    if (!hasWordInfo) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Word info & translate
        LayoutBuilder(builder: (context, _) {
          Widget wordcardWidget = WordInfoCard(
            original: model.original,
            pos: model.pos,
            pronunciation: model.pronunciation,
            wordId: model.id,
            lang: model.translateFrom!.code,
            collectionType: CollectionType.learning,
            hideCollection: true,
          );

          Widget translatedcardWidget = WordTranslatedCard(
            translated: model.translated,
            lang: model.translateTo!.code,
          );

          if (!AppPlatform.isPhone(context)) {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: wordcardWidget),
                  SizedBox(
                    width: AppDimens.subElementBetween,
                  ),
                  if (hasTranslated) Expanded(child: translatedcardWidget),
                ],
              ),
            );
          } else {
            return Column(
              children: [
                wordcardWidget,
                SizedBox(
                  height: AppDimens.subElementBetween,
                ),
                if (hasTranslated) translatedcardWidget,
              ],
            );
          }
        }),

        if (hasSynonyms) ...[
          SizedBox(
            height: AppDimens.cardBetween,
          ),
          // Synonyms
          SynonymsWidget(
            synonyms: model.synonyms,
          ),
        ],

        if (hasMeaning || hasExamples) ...[
          SizedBox(
            height: AppDimens.cardBetween,
          ),
          // Examples & Meaning
          LayoutBuilder(builder: (context, _) {
            Widget examplesWidget = ExamplesWidget(
              examples: model.examples,
              languageCode: model.translateFrom!.code,
            );
            Widget meaningWidget = MeaningWidget(
              meaning: model.meaning,
              languageCode: model.translateTo!.code,
            );

            if (!AppPlatform.isPhone(context)) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (hasExamples) Expanded(child: examplesWidget),
                    if (hasExamples && hasMeaning)
                      SizedBox(
                        width: AppDimens.subElementBetween,
                      ),
                    if (hasMeaning) Expanded(child: meaningWidget),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  if (hasMeaning) meaningWidget,
                  if (hasMeaning && hasExamples)
                    SizedBox(
                      height: AppDimens.subElementBetween,
                    ),
                  if (hasExamples) examplesWidget,
                ],
              );
            }
          }),
        ],
      ],
    );
  }
}
