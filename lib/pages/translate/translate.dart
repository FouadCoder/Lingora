import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/pages/translate/widgets/translation_input_output.dart';
import 'package:lingora/pages/translate/widgets/language_selector.dart';
import 'package:lingora/pages/translate/widgets/info_cards.dart';
import 'package:lingora/data/langauges_list.dart';
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

    return Scaffold(
      body: BlocListener<TranslateCubit, TranslateState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          final theme = Theme.of(context);
          switch (state.status) {
            case TranslateStatus.empty:
              showSnackBar(
                context,
                '',
                'translation_input_empty'.tr(),
                Icons.info_outline,
                theme.colorScheme.primary,
              );
              break;
            case TranslateStatus.failure:
              showSnackBar(
                context,
                '',
                'translation_failed'.tr(),
                Icons.error_outline,
                theme.colorScheme.error,
              );
              break;
            case TranslateStatus.success:
              showSnackBar(
                context,
                '',
                'translation_success_points'.tr(),
                Icons.verified_rounded,
                theme.colorScheme.secondary,
              );
              break;
            case TranslateStatus.loading:
            case TranslateStatus.initial:
              break;
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
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

                  const SizedBox(height: 24),
                  BlocBuilder<TranslateCubit, TranslateState>(
                    builder: (context, state) {
                      bool isLoading = state.status == TranslateStatus.loading;
                      return Column(
                        children: [
                          // Translation Input/Output
                          TranslationInputOutput(
                            controller: _inputController,
                            isLoading: isLoading,
                            onTranslate: () {
                              context.read<TranslateCubit>().translate();
                            },
                          ),

                          const SizedBox(height: 24),

                          // Info Cards
                          InfoCards(
                            isDesktop: isDesktop,
                            isTablet: isTablet,
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
      ),
    );
  }
}
