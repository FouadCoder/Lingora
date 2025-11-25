import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/settings/presentation/cubit/language_cubit.dart';
import 'package:lingora/features/settings/presentation/cubit/language_state.dart';

class LanguageSwitcher extends StatefulWidget {
  const LanguageSwitcher({super.key});

  @override
  State<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  Language? selectedLang;

  @override
  void initState() {
    super.initState();
    context.read<LanguageCubit>().getLanguage();
  }

  void _showLanguagePickerSheet() {
    final theme = Theme.of(context);
    final allLanguages = LanguageData.languages;

    // Only show a subset of languages
    final List<Language> languages = allLanguages.where((lang) {
      return [
        'en',
        'ar',
        'ru',
        'de',
        'es-es',
      ].contains(lang.code);
    }).toList();

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: AppPlatform.isPhone(context)
                ? MediaQuery.of(context).size.width
                : 200,
            padding: EdgeInsets.all(AppDimens.paddingM),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimens.radiusXL),
                topRight: Radius.circular(AppDimens.radiusXL),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(languages.length, (index) {
                return Padding(
                  padding: EdgeInsets.all(AppDimens.paddingM),
                  child: GestureDetector(
                    onTap: () {
                      selectedLang = languages[index];
                      context
                          .read<LanguageCubit>()
                          .setLanguage(languages[index]);
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: AppDimens.iconL,
                        ),
                        SizedBox(width: AppDimens.sectionSpacing),
                        Text(languages[index].name),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    selectedLang ??= LanguageData.getLanguageByCode('en');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Icon container
          Container(
            padding: EdgeInsets.all(AppDimens.paddingS),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimens.radiusL),
            ),
            child: Icon(
              Icons.language,
              color: theme.colorScheme.primary,
              size: AppDimens.iconL,
            ),
          ),

          SizedBox(width: AppDimens.subElementBetween),

          // Title + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'language'.tr(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppDimens.elementBetween),
                Text(
                  'app_language'.tr(),
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(width: AppDimens.elementBetween),

          // Langauge
          BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  _showLanguagePickerSheet();
                },
                child: AppCard(
                    backgroundColor: theme.colorScheme.onSurface,
                    child: Text("English")),
              );
            },
          )
        ],
      ),
    );
  }
}
