import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/pages/translate_screen/widgets/translation_input.dart';
import 'package:lingora/pages/translate_screen/widgets/language_selector.dart';
import 'package:lingora/pages/translate_screen/widgets/info_cards.dart';
import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/widgets/app_container.dart';
import 'package:lingora/widgets/flushbar.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final TextEditingController _inputController = TextEditingController();
  late Language translateFrom;
  late Language translateTo;

  @override
  void initState() {
    super.initState();
    final initial = context.read<TranslateCubit>().state;
    _inputController.text = initial.inputText;
    translateFrom = initial.sourceLanguage;
    translateTo = initial.targetLanguage;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppPlatform.isDesktop(context);
    final isTablet = AppPlatform.isTablet(context);

    return BlocListener<TranslateCubit, TranslateState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        final theme = Theme.of(context);

        switch (state.status) {
          case TranslateStatus.empty:
            showSnackBar(
              context,
              message: 'translation_input_empty'.tr(),
              icon: Icons.info_outline,
              iconColor: theme.colorScheme.primary,
            );
            break;

          case TranslateStatus.failure:
            showSnackBar(
              context,
              message: 'translation_failed'.tr(),
              icon: Icons.error_outline,
              iconColor: theme.colorScheme.error,
            );
            break;

          case TranslateStatus.success:
            showSnackBar(
              context,
              message: 'translation_success_points'.tr(),
              icon: Icons.verified_rounded,
              iconColor: theme.colorScheme.secondary,
            );
            break;

          case TranslateStatus.loading:
          case TranslateStatus.initial:
            break;
        }
      },
      child: Scaffold(
        body: AppContainer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: AppDimens.sectionBetween),
                // Language Selector
                LanguageSelector(
                  translateFrom: translateFrom,
                  translateTo: translateTo,
                  onSwap: () {
                    setState(() {
                      final temp = translateFrom;
                      translateFrom = translateTo;
                      translateTo = temp;
                    });
                    context.read<TranslateCubit>().swapLanguages();
                  },
                  onTaptranslateTo: (Language language) {
                    setState(() {
                      translateTo = language;
                    });
                    context.read<TranslateCubit>().updateLanguages(
                          from: translateFrom,
                          to: translateTo,
                        );
                  },
                  onTaptranslateFrom: (Language language) {
                    setState(() {
                      translateFrom = language;
                    });
                    context.read<TranslateCubit>().updateLanguages(
                          from: translateFrom,
                          to: translateTo,
                        );
                  },
                ),

                SizedBox(height: AppDimens.sectionBetween),

                BlocBuilder<TranslateCubit, TranslateState>(
                  builder: (context, state) {
                    bool isLoading = state.status == TranslateStatus.loading;
                    bool isSuccess = state.status == TranslateStatus.success &&
                        state.result != null;
                    return Column(
                      children: [
                        // Translation Input/Output
                        TranslationInput(
                          controller: _inputController,
                          isLoading: isLoading,
                          onTranslate: () {
                            context.read<TranslateCubit>().translate();
                          },
                        ),
                        SizedBox(height: AppDimens.sectionBetween),

                        // Info
                        if (isSuccess)
                          InfoCards(
                            isDesktop: isDesktop,
                            isTablet: isTablet,
                            model: state.result!,
                          ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
