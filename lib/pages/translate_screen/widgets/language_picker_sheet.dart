import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/data/langauges_list.dart';

class LanguagePickerSheet extends StatelessWidget {
  final bool istranslateFrom;
  final Language translateFrom;
  final Language translateTo;
  final Function(Language) onLanguageSelected;

  const LanguagePickerSheet({
    super.key,
    required this.istranslateFrom,
    required this.translateFrom,
    required this.translateTo,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final availableLanguages = LanguageData.languages;

    // Sort languages to show active one first
    final sortedLanguages = List.from(availableLanguages);
    sortedLanguages.sort((a, b) {
      final activeLanguage = istranslateFrom ? translateFrom : translateTo;
      if (a.code == activeLanguage.code) return -1;
      if (b.code == activeLanguage.code) return 1;
      return a.name.compareTo(b.name);
    });

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Text(
                  'select_language'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: AppDimens.titleContentBetween,
          ),

          // Languages list
          Expanded(
            child: ListView.builder(
              itemCount: sortedLanguages.length,
              itemBuilder: (context, index) {
                final language = sortedLanguages[index];
                final activeLanguage =
                    istranslateFrom ? translateFrom : translateTo;
                bool isActive = language.code == activeLanguage.code;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingS),
                  child: ListTile(
                    title: Text(
                      language.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).textTheme.bodyMedium!.color),
                    ),
                    subtitle: language.nativeName != language.name
                        ? Text(
                            language.nativeName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isActive
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.7),
                                ),
                          )
                        : null,
                    trailing: isActive
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.secondary,
                            size: AppDimens.iconL,
                          )
                        : null,
                    onTap: () {
                      onLanguageSelected(language);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
