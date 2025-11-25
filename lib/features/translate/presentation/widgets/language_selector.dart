import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/features/translate/presentation/cubit/translate_cubit.dart';
import 'package:lingora/features/translate/presentation/widgets/language_picker_sheet.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<TranslateCubit>().state;

    void showLanguagePicker(bool isSource) {
      showModalBottomSheet(
        showDragHandle: true,
        enableDrag: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          minHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        context: context,
        builder: (context) => LanguagePickerSheet(
          istranslateFrom: isSource,
          translateFrom: state.sourceLanguage,
          translateTo: state.targetLanguage,
          onLanguageSelected: (language) {
            if (isSource) {
              context.read<TranslateCubit>().updateLanguages(from: language);
            } else {
              context.read<TranslateCubit>().updateLanguages(to: language);
            }
          },
        ),
      );
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Source Language
          LanguageButton(
            languageName: state.sourceLanguage.name,
            onTap: () => showLanguagePicker(true),
            theme: theme,
          ),

          SizedBox(width: AppDimens.buttonTagHorizontal),

          // Swap Button
          GestureDetector(
            onTap: () => context.read<TranslateCubit>().swapLanguages(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(AppDimens.radiusXXL),
              ),
              child: Icon(
                Icons.swap_horiz,
                color: theme.colorScheme.secondary,
                size: 20,
              ),
            ),
          ),

          SizedBox(width: AppDimens.buttonTagHorizontal),

          // Target Language
          LanguageButton(
            languageName: state.targetLanguage.name,
            onTap: () => showLanguagePicker(false),
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String languageName;
  final VoidCallback onTap;
  final ThemeData theme;

  const LanguageButton({
    super.key,
    required this.languageName,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppPlatform.isPhone(context)
            ? MediaQuery.of(context).size.width * 0.30
            : 150,
        padding: const EdgeInsets.all(AppDimens.paddingS),
        decoration: BoxDecoration(
            color: theme.colorScheme.onSurface,
            borderRadius: BorderRadius.circular(AppDimens.radiusXXL)),
        child: Text(
          languageName,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
