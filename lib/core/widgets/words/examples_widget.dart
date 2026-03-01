import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/helper/direction_helper.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/header.dart';

class ExamplesWidget extends StatelessWidget {
  final List<String> examples;
  final String languageCode;

  const ExamplesWidget({
    super.key,
    required this.examples,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isRTL = isRightSide(languageCode);

    return Align(
      alignment: isRTL
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: AppCard(
        child: Column(
          children: [
            // Header with icon
            Header(
              icon: HeroIcons.chatBubbleLeftRight,
              title: 'examples'.tr(),
            ),
            SizedBox(
              height: AppDimens.sectionSpacing,
            ),

            // Example sentences
            Wrap(
              spacing: AppDimens.buttonTagHorizontal,
              runSpacing: AppDimens.buttonTagHorizontal,
              alignment: WrapAlignment.start,
              children: examples.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final example = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      example,
                      style: theme.bodyMedium,
                    ),
                    if (index != examples.length)
                      SizedBox(
                        height: AppDimens.buttonTagHorizontal,
                      ),
                    if (index != examples.length)
                      Divider(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.2),
                        height: 0.1,
                      ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
