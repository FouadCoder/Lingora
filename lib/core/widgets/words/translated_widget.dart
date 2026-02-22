import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/header.dart';
import 'package:lingora/core/widgets/icon_card.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:lingora/helper/direction_helper.dart';

class WordTranslatedCard extends StatelessWidget {
  final String translated;
  final String lang;

  const WordTranslatedCard({
    super.key,
    required this.translated,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return AppCard(
      child: Container(
        constraints: BoxConstraints(
          minHeight:
              AppPlatform.isDesktop(context) || AppPlatform.isTablet(context)
                  ? 200
                  : 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Header(
                  icon: HeroIcons.language,
                  title: 'translated'.tr(),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: AppDimens.buttonTagHorizontal,
                    ),
                    IconCard(
                      icon: HeroIcons.speakerWave,
                      onTap: () {
                        context.read<LibraryCubit>().playAudio(
                              translated,
                              lang,
                            );
                      },
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: AppDimens.sectionSpacing,
            ),
            // Translated words
            Text(
              translated,
              textAlign: isRightSide(lang) ? TextAlign.right : TextAlign.left,
              style: theme.titleMedium?.copyWith(
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
