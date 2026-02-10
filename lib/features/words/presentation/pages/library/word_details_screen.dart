import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/extensions/datetime_style.dart';
import 'package:lingora/core/widgets/examples_widget.dart';
import 'package:lingora/core/widgets/synonyms_widget.dart';
import 'package:lingora/core/widgets/meaning_widget.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/presentation/widgets/note_widget.dart';
import 'package:lingora/features/translate/presentation/widgets/translate_outputs.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_swtich.dart';

class WordDetailsScreen extends StatefulWidget {
  final WordEntity model;

  const WordDetailsScreen({super.key, required this.model});

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
                  original: widget.model.original,
                  pos: widget.model.pos,
                  pronunciation: widget.model.pronunciation,
                  word: widget.model,
                  lang: widget.model.translateFrom!.code,
                  collectionType: widget.model.collection.collectionType,
                ),

                SizedBox(
                  height: AppDimens.subElementBetween,
                ),

                // Translated
                WordTranslatedCard(
                  translated: widget.model.translated,
                  lang: widget.model.translateTo!.code,
                ),

                SizedBox(
                  height: AppDimens.cardBetween,
                ),

                // Meaning
                MeaningWidget(
                  meaning: widget.model.meaning,
                  languageCode: widget.model.translateTo!.code,
                ),
                SizedBox(
                  height: AppDimens.cardBetween,
                ),

                // Synonyms
                SynonymsWidget(
                  synonyms: widget.model.synonyms,
                ),

                SizedBox(
                  height: AppDimens.cardBetween,
                ),
                // Examples
                ExamplesWidget(
                  examples: widget.model.examples,
                  languageCode: widget.model.translateFrom!.code,
                ),

                SizedBox(
                  height: AppDimens.sectionBetween,
                ),

                // Notes
                LibraryNotes(
                  noteEntity: widget.model.note,
                  word: widget.model,
                ),

                // Reminders
                SizedBox(
                  height: AppDimens.sectionBetween,
                ),
                CustomSwtich(
                    title: 'reminders_title'.tr(),
                    description: activeNotifications
                        ? 'reminders_active'.tr()
                        : 'reminders_inactive'.tr(),
                    onChanged: (value) {
                      setState(() {
                        activeNotifications = value;
                      });
                    },
                    controller: ValueNotifier(activeNotifications),
                    icon: activeNotifications
                        ? HeroIcons.bell
                        : HeroIcons.bellSlash),

                // Translated at
                SizedBox(
                  height: AppDimens.sectionBetween,
                ),
                Text(
                  "${'translated_at'.tr()} ${widget.model.createdAt.toReadableDate()}",
                  style: theme.bodySmall,
                ),
              ],
            ),
          ),
        ));
  }
}
