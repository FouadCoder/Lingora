import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/widgets/app_card.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LevelCard extends StatefulWidget {
  const LevelCard({super.key});

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor:
          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // points & other text
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(FontAwesome.trophy),
                  SizedBox(
                    height: AppDimens.sectionSpacing,
                  ),
                  Text(
                    "your_points".tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline),
                  ),
                  SizedBox(
                    height: AppDimens.subElementBetween,
                  ),
                  Text(
                    "8912 XP",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),

              // trophy animation
              SizedBox(
                  height: 150,
                  width: 150,
                  child: Lottie.asset("assets/animation/trophy_2.json",
                      repeat: false))
            ],
          ),
          SizedBox(
            height: AppDimens.sectionSpacing,
          ),
          // Progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "progress_to_next_level".tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.outline),
              ),
              Text(
                "25/50 XP",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: AppDimens.subElementBetween,
          ),
          LinearPercentIndicator(
            lineHeight: 8,
            percent: 0.7,
            barRadius: const Radius.circular(10),
            padding: EdgeInsets.zero,
            progressColor: Theme.of(context).colorScheme.secondary,
            animation: true,
            animationDuration: 800,
            curve: Curves.easeInOut,
            backgroundColor: Theme.of(context).colorScheme.onSurface,
          )
        ],
      ),
    );
  }
}
