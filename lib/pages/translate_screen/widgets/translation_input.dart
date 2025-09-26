import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/extensions/theme_data.dart';
import 'package:lingora/widgets/app_card.dart';
import 'package:lingora/widgets/custom_button.dart';
import 'package:lingora/widgets/textfield.dart';

class TranslationInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTranslate;
  final bool isLoading;

  const TranslationInput({
    super.key,
    required this.controller,
    required this.onTranslate,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // English Input Box
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with label and icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'english'.tr(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // TODO: Implement camera functionality
                        },
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: theme.colorScheme.outline,
                          size: AppDimens.iconM,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      SizedBox(width: AppDimens.buttonTagHorizontal),
                      IconButton(
                        onPressed: () {
                          // TODO: Implement microphone functionality
                        },
                        icon: Icon(
                          Icons.mic_outlined,
                          color: theme.colorScheme.outline,
                          size: AppDimens.iconM,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      SizedBox(width: AppDimens.buttonTagHorizontal),
                      IconButton(
                        onPressed: () {
                          // TODO: Implement speaker functionality
                        },
                        icon: Icon(
                          Icons.volume_up_outlined,
                          color: theme.colorScheme.outline,
                          size: AppDimens.iconM,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: AppDimens.sectionSpacing),

              // Input Text Field
              CustomTextfield(
                controller: controller,
                label: '',
                hint: 'translation_hint'.tr(),
                highLight: false,
                highlightText: '',
                height: 72,
                onChange: (value) {
                  context.read<TranslateCubit>().updateInput(value);
                },
                borderColor: theme.border,
              ),

              SizedBox(height: AppDimens.sectionSpacing),

              // Translate Button
              Align(
                  alignment: Alignment.bottomRight,
                  child: CustomButton(
                      isLoading: isLoading,
                      loadingWidget: Text('translating'.tr()),
                      text: 'translate_button'.tr(),
                      color: theme.colorScheme.secondary,
                      function: onTranslate,
                      textColor: isLoading
                          ? theme.colorScheme.outline
                          : Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}
