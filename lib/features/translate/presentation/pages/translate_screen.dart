import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';

import 'package:lingora/features/translate/presentation/cubit/translate_cubit.dart';
import 'package:lingora/features/translate/presentation/cubit/translate_state.dart';
import 'package:lingora/features/library/presentation/widgets/word_collections.dart';
import 'package:lingora/features/translate/presentation/widgets/translate_input.dart';
import 'package:lingora/features/translate/presentation/widgets/language_selector.dart';
import 'package:lingora/features/translate/presentation/widgets/info_cards.dart';
import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_status.dart';
import 'package:lingora/core/widgets/flushbar.dart';

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
                // Language Selector
                LanguageSelector(),

                SizedBox(height: AppDimens.sectionSpacing),

                BlocBuilder<TranslateCubit, TranslateState>(
                  builder: (context, state) {
                    bool isLoading = state.status == TranslateStatus.loading;
                    bool isSuccess = state.status == TranslateStatus.success &&
                        state.result != null;
                    return Column(
                      children: [
                        // Translation Input
                        TranslationInput(
                          isLoading: isLoading,
                        ),

                        // Loading widget
                        if (isLoading)
                          CustomState(
                              animation: "assets/animation/loading_book.json",
                              title: "translating".tr(),
                              titleColor: Theme.of(context).colorScheme.outline,
                              message: ""),

                        SizedBox(
                          height: AppDimens.sectionBetween,
                        ),

                        if (isSuccess)
                          WordCollectionsWidget(
                            wordId: state.result!.id ?? "",
                            hideNotifications: false,
                          ),
                        if (isSuccess)
                          SizedBox(
                            height: AppDimens.sectionSpacing,
                          ),
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
