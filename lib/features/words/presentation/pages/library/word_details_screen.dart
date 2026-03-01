import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/extensions/datetime_style.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/words/examples_widget.dart';
import 'package:lingora/core/widgets/words/synonyms_widget.dart';
import 'package:lingora/core/widgets/words/meaning_widget.dart';
import 'package:lingora/core/widgets/words/translated_widget.dart';
import 'package:lingora/core/widgets/words/word_info_widget.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/presentation/widgets/note_widget.dart';
import 'package:lingora/features/words/presentation/widgets/reminder_switch_widget.dart';
import 'package:lingora/core/widgets/app_container.dart';

class WordDetailsScreen extends StatefulWidget {
  final WordEntity word;

  const WordDetailsScreen({super.key, required this.word});

  @override
  State<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends State<WordDetailsScreen> {
  bool activeNotifications = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
        appBar: AppBar(),
        body: AppContainer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Word info & translate
                LayoutBuilder(builder: (context, _) {
                  Widget wordcardWidget = WordInfoCard(
                    original: widget.word.original,
                    pos: widget.word.pos,
                    pronunciation: widget.word.pronunciation,
                    wordId: widget.word.id,
                    lang: widget.word.translateFrom!.code,
                    collectionType: widget.word.collection.collectionType,
                  );

                  Widget translatedcardWidget = WordTranslatedCard(
                    translated: widget.word.translated,
                    lang: widget.word.translateTo!.code,
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
                          Expanded(child: translatedcardWidget),
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
                        translatedcardWidget,
                      ],
                    );
                  }
                }),

                SizedBox(
                  height: AppDimens.cardBetween,
                ),

                // Synonyms
                SynonymsWidget(
                  synonyms: widget.word.synonyms,
                ),

                SizedBox(
                  height: AppDimens.cardBetween,
                ),
                // Examples & Meaning
                LayoutBuilder(builder: (context, _) {
                  Widget examplesWidget = ExamplesWidget(
                    examples: widget.word.examples,
                    languageCode: widget.word.translateFrom!.code,
                  );
                  Widget meaningWidget = MeaningWidget(
                    meaning: widget.word.meaning,
                    languageCode: widget.word.translateTo!.code,
                  );

                  if (!AppPlatform.isPhone(context)) {
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: examplesWidget),
                          SizedBox(
                            width: AppDimens.subElementBetween,
                          ),
                          Expanded(child: meaningWidget),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        examplesWidget,
                        SizedBox(
                          height: AppDimens.subElementBetween,
                        ),
                        meaningWidget,
                      ],
                    );
                  }
                }),

                SizedBox(
                  height: AppDimens.sectionBetween,
                ),

                // Notes
                LibraryNotes(
                  noteEntity: widget.word.note,
                  word: widget.word,
                ),

                SizedBox(
                  height: AppDimens.sectionBetween,
                ),

                // Reminders
                ReminderSwitchWidget(
                  wordId: widget.word.id,
                ),

                // Translated at
                SizedBox(
                  height: AppDimens.sectionBetween,
                ),
                Text(
                  "${'translated_at'.tr()} ${widget.word.createdAt.toReadableDate()}",
                  style: theme.bodySmall,
                ),
              ],
            ),
          ),
        ));
  }
}
