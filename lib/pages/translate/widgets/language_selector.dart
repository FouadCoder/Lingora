import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/pages/translate/widgets/language_picker_sheet.dart';

class LanguageSelector extends StatelessWidget {
  final Function(Language) onTaptranslateFrom;
  final Function(Language) onTaptranslateTo;
  final VoidCallback onSwap;

  final Language translateFrom;
  final Language translateTo;

  const LanguageSelector({
    super.key,
    required this.onTaptranslateFrom,
    required this.onTaptranslateTo,
    required this.translateFrom,
    required this.translateTo,
    required this.onSwap,
  });

  void pickLanguage(BuildContext context, bool istranslateFrom) {
    showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      context: context,
      builder: (BuildContext context) {
        return LanguagePickerSheet(
          istranslateFrom: istranslateFrom,
          translateFrom: translateFrom,
          translateTo: translateTo,
          onLanguageSelected: (Language selectedLanguage) {
            if (istranslateFrom) {
              onTaptranslateFrom(selectedLanguage);
            } else {
              onTaptranslateTo(selectedLanguage);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: .0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Source Language
          GestureDetector(
            onTap: () {
              pickLanguage(context, true);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
              ),
              child: Text(
                translateFrom.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spacingL),

          // Swap Button
          GestureDetector(
            onTap: onSwap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.swap_horiz,
                color: theme.colorScheme.outline,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spacingL),

          // Target Language
          GestureDetector(
            onTap: () {
              pickLanguage(context, false);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
              ),
              child: Column(
                children: [
                  Text(
                    translateTo.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
