import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/extensions/theme_data.dart';
import 'package:lingora/core/widgets/icon_card.dart';
import 'package:lingora/features/translate/presentation/cubit/translate_cubit.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/custom_button.dart';
import 'package:lingora/core/widgets/textfield.dart';
import 'package:lingora/features/translate/presentation/widgets/language_selector.dart';

class TranslationInput extends StatefulWidget {
  final bool isLoading;

  const TranslationInput({
    super.key,
    required this.isLoading,
  });

  @override
  State<TranslationInput> createState() => _TranslationInputState();
}

class _TranslationInputState extends State<TranslationInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<TranslateCubit>().state;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selector
          LanguageSelector(),
          const SizedBox(height: AppDimens.sectionSpacing),
          // Header with label and icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    border: Border(
                      left: BorderSide(
                        color: theme.colorScheme.secondary,
                        width: 4,
                      ),
                    )),
                child: Text(
                  state.sourceLanguage.name,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
              // Sound icon
              IconCard(icon: Icons.volume_up_outlined)
            ],
          ),

          // Input Text Field
          CustomTextfield(
            controller: _controller,
            label: '',
            hint: 'translation_hint'.tr(),
            highLight: false,
            highlightText: '',
            backgroundColor: theme.colorScheme.onSurface,
            height: AppPlatform.isPhone(context) ? 120 : 150,
            onChange: (value) {
              context.read<TranslateCubit>().updateInput(value);
            },
            borderColor: theme.border,
            borderRadius: AppDimens.radiusM,
          ),

          const SizedBox(height: AppDimens.sectionSpacing),

          // Translate Button
          Align(
            alignment: Alignment.bottomRight,
            child: CustomButton(
              isLoading: widget.isLoading,
              loadingWidget: Text('translating'.tr()),
              text: 'translate_button'.tr(),
              color: theme.colorScheme.secondary,
              function: () {
                context.read<TranslateCubit>().translate();
              },
              textColor:
                  widget.isLoading ? theme.colorScheme.outline : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
