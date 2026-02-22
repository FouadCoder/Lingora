import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/shimmer_box.dart';

class ReminderLoadingCard extends StatefulWidget {
  const ReminderLoadingCard({super.key});

  @override
  State<ReminderLoadingCard> createState() => _ReminderLoadingCardState();
}

class _ReminderLoadingCardState extends State<ReminderLoadingCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(context, width: 200),
                  SizedBox(height: AppDimens.elementBetween),
                  shimmerBox(context, width: 200),
                ],
              ),
            ),
            // Toggle switch
            SizedBox(width: AppDimens.paddingM),
            shimmerBox(context, width: 50, height: 20),
          ],
        ),
      ),
    );
  }
}
