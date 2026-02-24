import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UserProgressCard extends StatefulWidget {
  const UserProgressCard({super.key});

  @override
  State<UserProgressCard> createState() => _UserProgressCardState();
}

class _UserProgressCardState extends State<UserProgressCard> {
  @override
  void initState() {
    super.initState();
    context.read<LevelCubit>().fetchXp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LevelCubit, LevelState>(builder: (context, state) {
      // Loading
      if (state.status == LevelStatus.loading) {
        return LevelCard(
          xp: "",
          requiredXp: "",
          isLoading: true,
        );
      }

      // Success
      if (state.status == LevelStatus.success) {
        return LevelCard(
            xp: state.xp.toString(),
            requiredXp: state.level!.requiredXp.toString());
      }

      // Error
      return LevelCard(xp: "error".tr(), requiredXp: "");
    });
  }
}

class LevelCard extends StatelessWidget {
  final String xp;
  final String requiredXp;
  final bool isLoading;
  const LevelCard(
      {super.key,
      required this.xp,
      required this.requiredXp,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    double getProgress(String xpProgress, String requiXP) {
      final xpNumber = int.tryParse(xpProgress);
      final reqNumber = int.tryParse(requiXP);

      if (xpNumber != null && reqNumber != null && reqNumber > 0) {
        return (xpNumber / reqNumber).clamp(0.0, 1.0);
      }

      return 0.0;
    }

    return AppCard(
      backgroundColor: Theme.of(context).colorScheme.primary,
      border: Border.all(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        width: 1,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // points & other text
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeroIcon(HeroIcons.checkBadge),
                    SizedBox(
                      height: AppDimens.sectionSpacing,
                    ),
                    Text(
                      "your_points".tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                      height: AppDimens.subElementBetween,
                    ),
                    Text(
                      isLoading ? "loading".tr() : xp,
                      style: Theme.of(context).textTheme.displayLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ],
                ),
              ),

              // trophy animation
              Container(
                  constraints: BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  height: AppPlatform.isPhone(context)
                      ? MediaQuery.of(context).size.width * 0.30
                      : 150,
                  width: AppPlatform.isPhone(context)
                      ? MediaQuery.of(context).size.width * 0.30
                      : 150,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10)),
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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                width: AppDimens.subElementBetween,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  isLoading ? "--/-- XP" : "$xp/$requiredXp XP",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: AppDimens.subElementBetween,
          ),
          Container(
            height: 20,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
                color: Theme.of(context).scaffoldBackgroundColor),
            child: LinearPercentIndicator(
              lineHeight: 8,
              percent: getProgress(xp, requiredXp),
              barRadius: Radius.circular(AppDimens.radiusL),
              padding: EdgeInsets.zero,
              progressColor: Theme.of(context).colorScheme.primary,
              animation: true,
              animationDuration: 800,
              curve: Curves.easeInOut,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          )
        ],
      ),
    );
  }
}
