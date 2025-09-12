import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/cubit/cubit_app.dart';
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
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
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          // TODO: Implement microphone functionality
                        },
                        icon: Icon(
                          Icons.mic_outlined,
                          color: theme.colorScheme.outline,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          // TODO: Implement speaker functionality
                        },
                        icon: Icon(
                          Icons.volume_up_outlined,
                          color: theme.colorScheme.outline,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Input Text Field
              CustomTextfield(
                controller: controller,
                hintText: 'translation_hint'.tr(),
                highLight: false,
                highlightText: '',
                height: 72,
                onChange: (value) {
                  context.read<TranslateCubit>().updateInput(value);
                },
              ),
              const SizedBox(height: 12),

              // Translate Button
              Align(
                  alignment: Alignment.bottomRight,
                  child: CustomButton(
                      isLoading: isLoading,
                      text: 'translate_button'.tr(),
                      color: theme.colorScheme.secondary,
                      function: onTranslate,
                      textColor: theme.colorScheme.onSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}
