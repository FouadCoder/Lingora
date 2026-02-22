import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/helper/direction_helper.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/header.dart';

class MeaningWidget extends StatelessWidget {
  final String meaning;
  final String languageCode;

  const MeaningWidget({
    super.key,
    required this.meaning,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isRTL = isRightSide(languageCode);

    return Container(
      constraints: BoxConstraints(
        minHeight:
            AppPlatform.isDesktop(context) || AppPlatform.isTablet(context)
                ? 200
                : 100,
      ),
      child: AppCard(
        child: Column(
          children: [
            // Header with icon
            Header(
              icon: HeroIcons.lightBulb,
              title: 'meaning'.tr(),
            ),
            SizedBox(
              height: AppDimens.sectionSpacing,
            ),

            // Definition
            Align(
              alignment: isRTL
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: Text(
                meaning,
                style: theme.bodyMedium?.copyWith(
                  height: 1.4,
                ),
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
