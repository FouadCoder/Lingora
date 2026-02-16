import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/extensions/datetime_style.dart';
import 'package:lingora/core/widgets/examples_widget.dart';
import 'package:lingora/core/widgets/synonyms_widget.dart';
import 'package:lingora/core/widgets/meaning_widget.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:lingora/features/words/presentation/widgets/note_widget.dart';
import 'package:lingora/features/words/presentation/widgets/reminder_switch_widget.dart';
import 'package:lingora/features/translate/presentation/widgets/translate_outputs.dart';
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
                // Word Info
                WordInfoCard(
                  original: widget.word.original,
                  pos: widget.word.pos,
                  pronunciation: widget.word.pronunciation,
                  word: widget.word,
                  lang: widget.word.translateFrom!.code,
                  collectionType: widget.word.collection.collectionType,
                ),

                SizedBox(
                  height: AppDimens.subElementBetween,
                ),

                // Translated
                WordTranslatedCard(
                  translated: widget.word.translated,
                  lang: widget.word.translateTo!.code,
                ),

                SizedBox(
                  height: AppDimens.cardBetween,
                ),

                // Meaning
                MeaningWidget(
                  meaning: widget.word.meaning,
                  languageCode: widget.word.translateTo!.code,
                ),
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
                // Examples
                ExamplesWidget(
                  examples: widget.word.examples,
                  languageCode: widget.word.translateFrom!.code,
                ),

                SizedBox(
                  height: AppDimens.sectionBetween,
                ),

                // Notes
                LibraryNotes(
                  noteEntity: widget.word.note,
                  word: widget.word,
                ),

                // Reminders
                ReminderSwitchWidget(
                  word: widget.word,
                  onReminderChange: (updatedWord) {
                    context.read<LibraryCubit>().refreshWord(updatedWord);
                  },
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
