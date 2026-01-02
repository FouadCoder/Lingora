import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/extensions/datetime_style.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/presentation/widgets/note_widget.dart';
import 'package:lingora/features/translate/presentation/widgets/translate_outputs.dart';
import 'package:lingora/helper/direction_helper.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_swtich.dart';
import 'package:lingora/core/widgets/header.dart';

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

    // For text
    bool isRightSideText = isRightSide(widget.model.translateTo!.code);

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
                  height: AppDimens.sectionBetween,
                ),

                // Meaning
                Header(
                  icon: HeroIcons.lightBulb,
                  title: 'meaning'.tr(),
                ),

                SizedBox(
                  height: AppDimens.sectionSpacing,
                ),

                // Definition
                Align(
                  alignment: isRightSideText
                      ? AlignmentDirectional.centerStart
                      : AlignmentDirectional.centerEnd,
                  child: Text(
                    widget.model.meaning,
                    style: theme.bodyMedium?.copyWith(
                      height: 1.4,
                    ),
                    textAlign:
                        isRightSideText ? TextAlign.right : TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: AppDimens.sectionBetween,
                ),

                // Synonyms
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
                  children: widget.model.synonyms
                      .map((word) => _synonymChip(word, context))
                      .toList(),
                ),

                SizedBox(
                  height: AppDimens.sectionBetween,
                ),
                // Examples

                Header(
                  icon: HeroIcons.chatBubbleLeftRight,
                  title: 'examples'.tr(),
                ),
                SizedBox(
                  height: AppDimens.sectionSpacing,
                ),

                // Example sentences
                Wrap(
                  spacing: AppDimens.buttonTagHorizontal,
                  runSpacing: AppDimens.buttonTagHorizontal,
                  alignment:
                      isRightSideText ? WrapAlignment.end : WrapAlignment.start,
                  children: widget.model.examples.map((example) {
                    return Container(
                      padding: const EdgeInsets.all(8),
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
