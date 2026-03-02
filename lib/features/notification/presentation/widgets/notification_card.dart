import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/icon_card.dart';

class NotificationCard extends StatelessWidget {
  final String? title;
  final String? message;
  final HeroIcons? icon;
  final String? date;
  final Color? iconColor;
  const NotificationCard({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.iconColor,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0),
            child: IconCard(
              icon: icon ?? HeroIcons.bell,
              iconColor: iconColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title != null && title!.isNotEmpty
                      ? title!
                      : "notification_title".tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: AppDimens.elementBetween),
                Text(
                  message != null && message!.isNotEmpty
                      ? message!
                      : "notification_message_placeholder".tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: AppDimens.sectionSpacing),
                Align(
                  alignment: AlignmentGeometry.bottomRight,
                  child: Text(
                    date ?? "just_now".tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
