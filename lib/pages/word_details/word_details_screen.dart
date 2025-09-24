import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/extensions/datetime_style.dart';
import 'package:lingora/helper/direction_helper.dart';
import 'package:lingora/models/translate.dart';
import 'package:lingora/pages/translate_screen/widgets/translate_cards.dart';
import 'package:lingora/widgets/app_container.dart';
import 'package:lingora/widgets/custom_swtich.dart';
import 'package:lingora/widgets/header.dart';
import 'package:lingora/widgets/textfield.dart';

class WordDetailsScreen extends StatefulWidget {
  final Translate model;
  const WordDetailsScreen({super.key, required this.model});

  @override
  State<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends State<WordDetailsScreen> {
  final TextEditingController noteController = TextEditingController();
  bool activeNotifications = false;

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

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
            // Translated
            WordTranslatedCard(model: widget.model),

            SizedBox(
              height: AppDimens.subElementBetween,
            ),

            // Word Info
            WordInfoCard(model: widget.model),

            SizedBox(
              height: AppDimens.sectionBetween,
            ),

            // Meaning
            Header(
              icon: Icons.lightbulb_outline,
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
                textAlign: isRightSideText ? TextAlign.right : TextAlign.left,
              ),
            ),
            SizedBox(
              height: AppDimens.sectionBetween,
            ),

            // Synonyms
            Header(
              icon: MaterialCommunityIcons.cards,
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
              icon: Icons.format_quote,
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

            // Category
            Header(icon: MaterialCommunityIcons.tag, title: 'category'.tr()),
            CustomTextfield(
              controller: TextEditingController(),
              label: '',
              hint: '',
              readOnly: true,
              onTap: () {},
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),

            // Notes
            SizedBox(
              height: AppDimens.sectionBetween,
            ),
            Header(icon: MaterialCommunityIcons.pen, title: 'notes'.tr()),
            CustomTextfield(
                controller: noteController, label: '', hint: 'notes_hint'.tr()),

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
                    ? Icons.notifications
                    : Icons.notifications_off),

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
      )),
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
